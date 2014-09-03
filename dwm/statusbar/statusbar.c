/* made by profil 2011-12-29.
**
** Compile with:
** gcc -Wall -pedantic -std=c99 -lX11 status.c
*/

#define _BSD_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <X11/Xlib.h>

#define timeval time_timeval
#define timespec time_timespec
#include <alsa/asoundlib.h>
#include <alsa/mixer.h>

static Display *dpy;

void setstatus(char *str) {
	XStoreName(dpy, DefaultRootWindow(dpy), str);
	XSync(dpy, False);
}

char* getcmd(char* cmd){
    char *buffer = malloc(1000);

    FILE* pipe = popen(cmd, "r");

    if (NULL == pipe) {
        perror("pipe");
            exit(1);
    } 

    fgets(buffer, sizeof(buffer), pipe);

    pclose(pipe);
    buffer[strlen(buffer)] = '\0';
    return buffer;
}

float getvolume(snd_mixer_t *handle, const char* vol_ch)
{
	int mute = 0;
	long vol = 0, max = 0, min = 0;
	snd_mixer_elem_t *pcm_mixer, *max_mixer;
	snd_mixer_selem_id_t *vol_info, *mute_info;

	/*ToDo: maybe move all this to main?*/
	snd_mixer_handle_events(handle);
	snd_mixer_selem_id_malloc(&vol_info);
	snd_mixer_selem_id_malloc(&mute_info);
	snd_mixer_selem_id_set_name(vol_info, vol_ch);
	snd_mixer_selem_id_set_name(mute_info, vol_ch);
	pcm_mixer = snd_mixer_find_selem(handle, vol_info);
	max_mixer = snd_mixer_find_selem(handle, mute_info);
	snd_mixer_selem_get_playback_volume_range(pcm_mixer, &min, &max);
	snd_mixer_selem_get_playback_volume(pcm_mixer, 0, &vol);
	snd_mixer_selem_get_playback_switch(max_mixer, 0, &mute);
	snd_mixer_selem_id_free(vol_info);
	snd_mixer_selem_id_free(mute_info);

    return ((float)vol/(float)max)*100;
}

char *getdatetime() {
	char *buf;
	time_t result;
	struct tm *resulttm;

	if((buf = malloc(sizeof(char)*65)) == NULL) {
		fprintf(stderr, "Cannot allocate memory for buf.\n");
		exit(1);
	}
	result = time(NULL);
	resulttm = localtime(&result);
	if(resulttm == NULL) {
		fprintf(stderr, "Error getting localtime.\n");
		exit(1);
	}
	if(!strftime(buf, sizeof(char)*65-1, "%d %b %H:%M", resulttm)) {
		fprintf(stderr, "strftime is 0.\n");
		exit(1);
	}
	
	return buf;
}

float getbattery() {
	FILE *fd;
	int energy_now, energy_full, voltage_now;

	fd = fopen("/sys/class/power_supply/BAT0/charge_now", "r");
	if(fd == NULL) {
		fprintf(stderr, "Error opening energy_now.\n");
		return -1;
	}
	fscanf(fd, "%d", &energy_now);
	fclose(fd);


	fd = fopen("/sys/class/power_supply/BAT0/charge_full", "r");
	if(fd == NULL) {
		fprintf(stderr, "Error opening energy_full.\n");
		return -1;
	}
	fscanf(fd, "%d", &energy_full);
	fclose(fd);


	fd = fopen("/sys/class/power_supply/BAT0/voltage_now", "r");
	if(fd == NULL) {
		fprintf(stderr, "Error opening voltage_now.\n");
		return -1;
	}
	fscanf(fd, "%d", &voltage_now);
	fclose(fd);

	float battery = ((float)energy_now * 1000 / (float)voltage_now) * 100 / ((float)energy_full * 1000 / (float)voltage_now);

	return battery;
}

int main(int argc, char* argv[]) {
	char *status;
    char volume[20];
	char *datetime;
	char bat[20] = "";
    int laptop = 0;
    char hostname[30];
    gethostname(hostname, 30); 
    printf("%s\n", hostname);
    
    if (strcmp(hostname, "johan-laptop") == 0){
        laptop = 1;
        printf("This is a laptop\n");
    }
    else {
        printf("This is not a laptop\n");
    }

    snd_mixer_t *handle;
	snd_mixer_open(&handle, 0);
	snd_mixer_attach(handle, "default");
	const char* vol_ch = "Master";
	snd_mixer_selem_register(handle, NULL, NULL);
	snd_mixer_load(handle);

	if (!(dpy = XOpenDisplay(NULL))) {
		fprintf(stderr, "Cannot open display.\n");
		return 1;
	}

	if((status = malloc(200)) == NULL)
		exit(1);
	

	for (;;usleep(1000000)) {
	    datetime = getdatetime();
        //volume = getcmd("$HOME/Scripts/volume\\ get.sh");
        sprintf(volume, "%.0f%", getvolume(handle, vol_ch));
		if (laptop){
            sprintf(bat, " Bat: %.0f% |", getbattery());
        }

        snprintf(status, 200, "Vol: %s% |%s %s ", volume, bat, datetime );

		free(datetime);
		setstatus(status);
	}

	free(status);
	XCloseDisplay(dpy);

	return 0;
}

