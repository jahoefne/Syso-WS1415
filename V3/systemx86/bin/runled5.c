#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>

void runled5IfButtonIsPressed() {
  FILE *inputfile;
  char value[2];
  bool killed = false;
  inputfile = fopen ("/sys/class/gpio/gpio17/value", "r");
  
  while (1) { 
		fscanf (inputfile, "%1c", value);
		value[1] = '\0';

		if(strcmp(value, "0" ) == 0 || access("/www/cgi-bin/clicked", F_OK)){
			if (killed) {
				printf("Start");
				system("/bin/led5 &");
				system("rm -rf /www/cgi-bin/clicked");
				killed = false;
			}else if (!killed) {
				printf("Stop");
				system("kill -2 led5");		
				system("rm -rf /www/cgi-bin/clicked");
				killed = true;
			}
		}
		while(strcmp(value, "0") == 0 || access("/www/cgi-bin/clicked", F_OK)){
			fscanf(inputfile, "%1c", value);
			value[1] = '\0';				
			system("rm -rf /www/cgi-bin/clicked");
		}
   }
   fclose (inputfile);
}

int main() {
	runled5IfButtonIsPressed();
	return 0;
}
