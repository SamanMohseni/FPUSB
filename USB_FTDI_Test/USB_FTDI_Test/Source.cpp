#include <Windows.h>
#include <iostream>
#include <cstdlib>
#include <stdint.h>
#include <math.h>
#include <string>
#include <iomanip>

#include "ftd2xx.h"

using namespace std;

union number {
	double d;
	uint64_t i;
};

string DoubleToBitstream(union number n, bool space = false) {
	string res;

	int i;
	uint64_t base = 1;

	int sign = (n.i & (base << 63)) > 0;
	res.push_back('0' + sign);
	if (space){
		res.push_back('_');
	}

	int exp = 0;
	for (i = 62; i > 51; i--) {
		exp |= ((n.i & (base << i)) >> 52);
	}
	exp -= 1022;
	if (exp > 127){
		exp = 127;
	}
	else if (exp < -128){
		exp = -128;
	}
	for (i = 7; i >= 0; i--){
		res.push_back('0' + ((exp & (1 << i)) > 0));
	}

	if (space){
		res.push_back('_');
	}

	res.push_back('1');

	for (i = 51; i >= 35; i--) {
		res.push_back('0' + ((n.i & (base << i)) >> i));
	}
	return res;
}

string DoubleToBitstream(double d, bool space = false) {
	union number n;
	n.d = d;
	return DoubleToBitstream(n, space);
}

double BinaryToDouble(string number){
	double res = 0;

	int fraction = 0;
	for (int i = 9; i < 27; i++){
		fraction |= (number[i] - '0') << (17 - (i - 9));
	}

	char exp = 0;
	for (int i = 1; i < 9; i++){
		exp |= (number[i] - '0') << (7 - (i - 1));
	}

	res = fraction;
	res *= pow(2.0, exp - 18);
	if (number[0] - '0'){
		return -res;
	}
	return res;
}

int BinaryToInt(string number){
	int res = 0;
	for (int i = 0; i < 27; i++){
		res |= (number[i] - '0') << (26 - i);
	}
	return res;
}

string IntToBinary(int number){
	string res;
	for (int i = 26; i >= 0; i--){
		res.push_back('0' + ((number & (1 << i)) > 0));
	}
	return res;
}

#define TransmitBufferSize 8
#define ReceiveBufferSize 4

int main(){
	FT_HANDLE handle;
	FT_STATUS status;

	DWORD bytesWritten;
	DWORD bytesRead;

	unsigned char receiveBuffer[ReceiveBufferSize];
	unsigned char transmitBuffer[TransmitBufferSize];

	status = FT_OpenEx((PVOID) "Digilent USB Device B", FT_OPEN_BY_DESCRIPTION, &handle);
	if (status != FT_OK) {
		cout << "Failed to open the Device!" << endl;
		return 0;
	}
	else {
		cout << "Device Opened Successfully" << endl;
	}

	status = FT_SetUSBParameters(handle, ReceiveBufferSize, TransmitBufferSize);
	FT_Purge(handle, FT_PURGE_RX);
	status = FT_SetFlowControl(handle, FT_FLOW_RTS_CTS, 0, 0);

	while (true){
		double first_num, second_num;

		cout << ">>Enter first number: ";
		cin >> first_num;
		cout << "**Binary equivalent: " << DoubleToBitstream(first_num, true) << endl;

		cout << ">>Enter second number: ";
		cin >> second_num;
		cout << "**Binary equivalent: " << DoubleToBitstream(second_num, true) << endl << endl;

		int first, second;

		first = BinaryToInt(DoubleToBitstream(first_num));
		second = BinaryToInt(DoubleToBitstream(second_num));

		for (int i = 0; i < 4; i++){
			transmitBuffer[i] = first % 256;
			first >>= 8;
		}
		for (int i = 4; i < 8; i++){
			transmitBuffer[i] = second % 256;
			second >>= 8;
		}

		status = FT_Write(handle, transmitBuffer, TransmitBufferSize, &bytesWritten);
		
		status = FT_Read(handle, receiveBuffer, ReceiveBufferSize, &bytesRead);

		int res = ((int*)receiveBuffer)[0];
		cout << ">>Result from FPGA: " << IntToBinary(res);
		cout << " <==> " << setprecision(6) << BinaryToDouble(IntToBinary(res)) << endl;

		cout << "**Expected result: " << setprecision(6) << first_num * second_num << endl << endl;
	}

	status = FT_Close(handle);

	return 0;
}