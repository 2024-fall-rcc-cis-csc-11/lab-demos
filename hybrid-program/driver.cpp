
#include <iostream>
using std::cout, std::endl;

extern "C"
{
	void hello();
}

int main()
{
	cout << "My name is Chaplain Mondover. Welcome to my driver program!" << endl;
	cout << "I will now call the hello module ..." << endl;

	hello();

	cout << "The driver is now back in control." << endl;
	cout << "Goodbye!" << endl;

	return 0;
}


