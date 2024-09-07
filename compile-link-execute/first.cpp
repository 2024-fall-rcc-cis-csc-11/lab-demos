

//	Note that a main() must appear in exactly 1 source file, somewhere, per executable.
//	(no more, no less)

//	(unless you're making a pure assembly program (non gcc), in which case you'll need _start exactly once)


#include <iostream>

extern "C"
{
	void second();
	void third();
}

int main()
{
	std::cout << "Hello from first.cpp" << std::endl;
	second();
	third();
	
	return 0;
}
