// Serial communication with kernel

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <stdint.h>
#include <termios.h>
#include <time.h>

struct termios tio;

int open_serial(char* dev)
{
	int fd = open(dev, O_RDWR | O_NOCTTY | O_NONBLOCK);
	if(fd == -1)
	{
		printf("Failed to open port.\n");
		exit(-1);
	}
	
	if(!isatty(fd))
	{
		printf("%s is not a TTY.\n", dev);
		close(fd);
		exit(-1);
	}
	
	if(tcgetattr(fd, &tio) == -1) {
		close(fd);
		exit(-1);
	}
	
	tio.c_cc[VTIME] = 0;
    tio.c_cc[VMIN] = 0;

    tio.c_iflag = 0;
    tio.c_oflag = 0;
    tio.c_cflag = CS8 | CREAD | CLOCAL;
    tio.c_lflag = 0;

	
	
	if(cfsetospeed(&tio, B115200) < 0)
	{
		printf("Could not set baud rate.\n");
		close(fd);
		exit(-1);
	}
	
	if(cfsetispeed(&tio, B115200) < 0)
	{
		printf("Could not set baud rate.\n");
		close(fd);
		exit(-1);
	}
	
	if(tcsetattr(fd, TCSAFLUSH, &tio) == -1)
	{
		printf("Failed to set port attributes.\n");
		perror("tcsetattr()");
		close(fd);
		exit(-1);
	}
	
	fcntl(fd, F_SETFL, 0);
	return fd;
}

int request_kernel_OK(int fd, int timeout)
{
	unsigned char c = 0x05;
	clock_t start = clock();
	clock_t end = start;
	write(fd, &c, 1);
	while(c != 0x06)
	{
		end = clock();
		
		if(read(fd, &c, 1) > 0)
		{
			printf("Received data on serial port:%d\n", c);
			fflush(stdout);
			return (c == 0x06 ? 0 : -1);
		}
	
	}
	return -1;
}

int send_kernel(int fd, char* kpath) {
	printf("Sending kernel...");
	FILE *file;
	char *buffer;
	unsigned long fileLen;

	//Open file
	file = fopen(kpath, "rb");
	if (!file)
	{
		fprintf(stderr, "Unable to open file %s", kpath);
		return -1;
	}
	
	//Get file length
	fseek(file, 0, SEEK_END);
	fileLen=ftell(file);
	fseek(file, 0, SEEK_SET);

	//Allocate memory
	buffer=(char *)malloc(fileLen+1);
	if (!buffer)
	{
		fprintf(stderr, "Memory error!");
                                fclose(file);
		return -1;
	}

	//Read file contents into buffer
	fread(buffer, fileLen, 1, file);
	fclose(file);
	uint8_t byte = 0x03;
	unsigned char c = 0x05;
	write(fd, &byte, 1);
	while(c != 0x06)
	{
		
		if(read(fd, &c, 1) > 0)
		{
			printf("Received data on serial port:%d\n", c);
			fflush(stdout);
		}
	
	}
	// for (int i = 0; i < 4; ++i)
	// {
	// 	byte = (uint8_t)((fileLen >> (i * 8)) & 0x000000ff);
	// 	write(fd, &byte, 1);
	// }

	write(fd, &fileLen, 4);

	// for (int i = 0; i < fileLen; ++i)
	// {
	// 	write(fd, &buffer + i, 1);
	// }

	free(buffer);

	printf("done\n");
	fflush(stdout);
	return 0;
}

int main(int argc, char** argv)
{
	int fd = open_serial(argv[1]);
	printf("Trying...");
	fflush(stdout);
	if(request_kernel_OK(fd, 1000) == 0)
	{
		printf("Kernel responded OK.\n");
		fflush(stdout);
	}
	if(argc > 2) {
		send_kernel(fd, argv[2]);
	}
	close(fd);
	return 0;
}

