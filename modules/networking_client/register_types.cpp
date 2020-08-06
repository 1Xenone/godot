#include "register_types.h"
#include "core/class_db.h"
#include "networking_client.h"

void register_networking_client_types() {
	ClassDB::register_class<NetworkingClient>();
}

void unregister_networking_client_types() {
}
