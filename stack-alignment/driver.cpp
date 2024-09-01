
#include <iostream>
using std::cout, std::endl;

extern "C"
{
	void whoops();
}

int main()
{
	cout << "My name is Niles Peppertrout. Welcome to my driver program!" << endl;
	cout << "I will now call the whoops module ..." << endl;
	
	whoops();
	
	cout << "The driver is now back in control." << endl;
	cout << "Goodbye!" << endl;
	
	return 0;
}


