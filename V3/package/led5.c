#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/timeb.h>
#include <time.h>
#include <pthread.h>
#include <signal.h>
#include <unistd.h>

/* 
	compile with "gcc led5.c -o led5 -lpthread"
*/
bool active = true, btnClickFinished = true, swClicked = false;
const int HZ = 5;
// make thread known global so it can be canceled on interrupt
pthread_t work_thread;

void writeToFile(char *file, char *text) {
  FILE *outputfile;
  outputfile = fopen (file, "w");

  if (outputfile == NULL) {
    printf("Can't open file: %s.", file);
    return;
  }

  fprintf (outputfile, "%s", text);
  fflush(outputfile);
  fclose (outputfile);
}

void enableLED() {
	if (!active) return;
	writeToFile("/sys/class/gpio/export", "18");
	writeToFile("/sys/class/gpio/gpio18/direction", "out");
	writeToFile("/sys/class/gpio/gpio18/value", "0");
	//printf("on\n");
}

void disableLED() {
	writeToFile("/sys/class/gpio/unexport", "18");
	//printf("off\n");
}

void checkIfButtonIsPressed() {
  FILE *inputfile;
  char value[2];

  inputfile = fopen ("/sys/class/gpio/gpio17/value", "r");

  if (inputfile != NULL) {
    fscanf (inputfile, "%1c", value);
    value[1] = '\0';
    if (strcmp(value, "0") == 0) {
		if (btnClickFinished) {
			btnClickFinished = false;
			active = !active;	
		}		
	} else {
		btnClickFinished = true;
	}
    fclose (inputfile);
  }
}

void checkIfSwButtonIsPressed() {
	int pressed = access("/www/cgi-bin/clicked", F_OK);
	if (pressed!=-1) {
		active = !active;
		system("rm -rf /www/cgi-bin/clicked");
	}
}

void *work() {
	struct timespec t;
	int i;

	for (i = 0; i >= 0; i++)  {
		clock_gettime(CLOCK_REALTIME, &t);
		t.tv_nsec += 1000000000 / HZ;

		if (t.tv_nsec >= 1000000000) {
		    t.tv_nsec -= 1000000000;
		    t.tv_sec++;
		}
		clock_nanosleep(CLOCK_REALTIME, TIMER_ABSTIME, &t, NULL);

		checkIfButtonIsPressed();
		checkIfSwButtonIsPressed();
		
		if (i % 2 == 0)	{
			enableLED();
			i = 0;
		} else {
			disableLED();
		}
	}

	return NULL;
}

void interrupt(int sig)
{ 
	// stop thread
	pthread_cancel(work_thread);
	// show interrupt signal
	//printf("Interrupt: %d\n", sig);
	// disable LED
	disableLED();
	exit(-1);
}

int main() {
	// register interrupt handler
	signal (SIGINT, interrupt);

	if(pthread_create(&work_thread, NULL, work, NULL)) {
		fprintf(stderr, "Error creating thread\n");
		return 1;
	}

	if(pthread_join(work_thread, NULL)) {
		fprintf(stderr, "Error joining thread\n");
		return 2;
	}

	return 0;
}
