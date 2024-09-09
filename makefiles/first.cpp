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


