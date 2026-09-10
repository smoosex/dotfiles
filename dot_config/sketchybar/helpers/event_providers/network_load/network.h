#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <net/if.h>
#include <net/if_mib.h>
#include <sys/sysctl.h>

struct network {
	uint32_t row;
	struct ifmibdata data;
	struct timeval tv_nm1, tv_n, tv_delta;
	double up_bps;
	double down_bps;
};

static inline void format_rate(double bytes_per_sec, char* buf, size_t n) {
	if (!(bytes_per_sec > 0)) {
		snprintf(buf, n, "0.0K");
		return;
	}
	if (bytes_per_sec >= 1000.0 * 1000.0) {
		snprintf(buf, n, "%.1fM", bytes_per_sec / 1000000.0);
	} else {
		snprintf(buf, n, "%.1fK", bytes_per_sec / 1000.0);
	}
}

static inline void ifdata(uint32_t net_row, struct ifmibdata* data) {
	static size_t size = sizeof(struct ifmibdata);
	static int32_t data_option[] = { CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_IFDATA, 0, IFDATA_GENERAL };
	data_option[4] = net_row;
	sysctl(data_option, 6, data, &size, NULL, 0);
}

static inline void network_init(struct network* net, char* ifname) {
	memset(net, 0, sizeof(struct network));

	static int count_option[] = { CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_SYSTEM, IFMIB_IFCOUNT };
	uint32_t interface_count = 0;
	size_t size = sizeof(uint32_t);
	sysctl(count_option, 5, &interface_count, &size, NULL, 0);

	for (int i = 0; i < interface_count; i++) {
		ifdata(i, &net->data);
		if (strcmp(net->data.ifmd_name, ifname) == 0) {
			net->row = i;
			break;
		}
	}
}

static inline void network_update(struct network* net) {
	gettimeofday(&net->tv_n, NULL);
	timersub(&net->tv_n, &net->tv_nm1, &net->tv_delta);
	net->tv_nm1 = net->tv_n;

	uint64_t ibytes_nm1 = net->data.ifmd_data.ifi_ibytes;
	uint64_t obytes_nm1 = net->data.ifmd_data.ifi_obytes;
	ifdata(net->row, &net->data);

	double time_scale = (net->tv_delta.tv_sec + 1e-6 * net->tv_delta.tv_usec);
	if (time_scale < 1e-6 || time_scale > 1e2) {
		return;
	}

	net->down_bps = (double)(net->data.ifmd_data.ifi_ibytes - ibytes_nm1) / time_scale;
	net->up_bps = (double)(net->data.ifmd_data.ifi_obytes - obytes_nm1) / time_scale;
}
