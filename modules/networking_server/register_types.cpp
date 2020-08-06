#include "register_types.h"
#include "core/class_db.h"
#include "networking_server.h"

void register_networking_server_types() {
	ClassDB::register_class<NetworkingServer>();
}

void unregister_networking_server_types() {
}
