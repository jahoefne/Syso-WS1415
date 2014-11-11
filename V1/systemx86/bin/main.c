#include <sys/sysinfo.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(){

	struct sysinfo sys_info;
	sysinfo(&sys_info);

	printf("Hello user!\n");
	printf("Uptime:%ld\n",sys_info.uptime);
	printf("Total RAM: %ld\n", sys_info.totalram);
	printf("Free RAM: %ld\n", sys_info.freeram);
	printf("Process count: %d\n", sys_info.procs);
	printf("Page size: %ldByte\n", sysconf(_SC_PAGESIZE));
	return 0;
}
