import std.stdio;
import std.process;
import std.conv;
import std.format;
import std.file;
import std.string;
import std.array;
import std.math;
import std.regex;
_sysinfo sysinfo;

struct _sysinfo {
	string username;
	double memory;
	int cores;
	string disk_usage;
	string disk_size;
}

void get_username() {
	sysinfo.username = to!string(strip(["whoami"].execute.output));
}

void get_memory() {
	File file = File("/proc/meminfo", "r");
	sysinfo.memory = ceil(to!double(file.readln().split[1])/(1024^^2));
	file.close();
}

void get_cores() {
	sysinfo.cores = to!int(strip(["nproc"].execute.output));
}

void get_disk() {
	string data  = to!string(strip(["df","-h"].execute.output));
	auto m = matchFirst(data, regex(`\/dev\/sdb2\s+(?P<size>.+?)\s.+?(?P<use>\d\%).+?`));
	sysinfo.disk_size = m["size"];
	sysinfo.disk_usage = m["use"];

}

void main() {
	get_username();
	get_memory();
	get_cores();
	get_disk();
	writeln(format!"Username: %s \nMemory: %sGB\nCores: %s\nDisk Size: %s\nDisk Usage %s"(sysinfo.username,sysinfo.memory,sysinfo.cores,sysinfo.disk_size,sysinfo.disk_usage));	
}
