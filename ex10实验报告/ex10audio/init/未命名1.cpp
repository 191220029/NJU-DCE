#include <iostream>
#include<string.h>
using namespace std;

#define Hz ,

long double freq[12][4] = {
	{130.81, 261.63, 523.25, 1046.5},
	{138.59, 277.18, 554.37, 1108.7},
	{146.83, 293.66, 587.33, 1174.7},
	{155.56 Hz 311.13 Hz 622.25 Hz 1244.5 Hz},
	{164.81 Hz 329.63 Hz 659.26 Hz 1318.5 Hz},
	{174.61 Hz 349.23 Hz 698.46 Hz 1396.9 Hz},
	{185.00 Hz 369.99 Hz 739.99 Hz 1480.0 Hz},
	{196.00 Hz 392.00 Hz 783.99 Hz 1568.0 Hz},
	{207.65 Hz 415.30 Hz 830.61 Hz 1661.2 Hz},
	{220.00 Hz 440.00 Hz 880.00 Hz 1760.0 Hz},
	{233.08 Hz 466.16 Hz 932.33 Hz 1864.7 Hz},
	{246.94 Hz 493.88 Hz 987.77 Hz 1975.5 Hz},
};

long double res[12][4];
string s[12] = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};

long double cald(long double f){
	return (long double)(f * 65536)/48000;
}

void prt(){
	for(int i = 0; i < 12; i++){
		cout << s[i] << ":  ";
		for(int j = 0; j < 4; j++){
			//cout << hex << res[i][j] << "    ";
			printf("%x,   ", (int)res[i][j]);
		}
		cout << endl;
	}
}

void prt_raw(){
	cout << "raw_data:\n" ;
	for(int i = 0; i < 12; i++){
		cout << s[i] << ":  ";
		for(int j = 0; j < 4; j++){
			//cout << hex << freq[i][j] << "    ";
			printf("%x,   ", (int)freq[i][j]);
		}
		cout << endl;
	}
}

int main(){
	for(int i = 0; i < 12; i++){
		for(int j = 0; j < 4; j++){
			res[i][j] = cald(freq[i][j]);
			//cout << res[i][j] << endl;
		}
	}
	prt_raw(); cout << endl;
	prt();
	return 0;
} 
