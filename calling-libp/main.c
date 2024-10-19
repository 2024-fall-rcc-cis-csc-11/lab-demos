

//
#include <stdio.h>

extern long demo();

//
int main(int argc, char * argv[])
{
	//
	printf("Welcome to the libP demo driver.\n");
	printf("The main program will now call the demo() function.\n");
	
	//
	demo();
	
	printf("Have a nice day. Main will now return 0 to the operating system.\n");
	
	return 0;
}

