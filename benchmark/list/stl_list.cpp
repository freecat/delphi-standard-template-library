#include <iostream>
#include <time.h>  

#include <list> 

using namespace std;

clock_t start_time; 

inline void start_timer() { start_time = clock(); } 


inline double timer() 
{ 
  clock_t end_time = clock(); 
  return (end_time - start_time)/double(CLOCKS_PER_SEC)*1000; 
} 

void pushback_test() 
{
	list<int> l;
	int i;

	start_timer();

	for (i = 1; i <= 1000000; i++) l.push_back(i);

	cout << "pushing 1000000 elements into a list takes: " << timer() << "ms" << endl;
}

void sort_test() 
{
	list<int> l;
	int i;

	for (i = 1; i <= 1000000; i++) l.push_back(random(30000));

	start_timer();
	l.sort();

	cout << "sorting 1000000 elements takes: " << timer() << "ms" << endl;
}

int main()
{
	pushback_test();
	sort_test();

	return 0;
}