#include <unistd.h>
#include "network.h"
#include "../sketchybar.h"

int main(int argc, char** argv) {
	float update_freq;
	if (argc < 4 || (sscanf(argv[3], "%f", &update_freq) != 1)) {
		printf("Usage: %s \"<interface>\" \"<event-name>\" \"<event_freq>\"\n", argv[0]);
		exit(1);
	}

	alarm(0);
	char event_message[512];
	snprintf(event_message, 512, "--add event '%s'", argv[2]);
	sketchybar(event_message);

	struct network network;
	network_init(&network, argv[1]);
	char trigger_message[512];
	char up[16];
	char down[16];
	for (;;) {
		network_update(&network);
		format_rate(network.up_bps, up, sizeof(up));
		format_rate(network.down_bps, down, sizeof(down));

		snprintf(trigger_message, 512, "--trigger '%s' upload='%s' download='%s'", argv[2], up, down);
		sketchybar(trigger_message);

		usleep(update_freq * 1000000);
	}
	return 0;
}
