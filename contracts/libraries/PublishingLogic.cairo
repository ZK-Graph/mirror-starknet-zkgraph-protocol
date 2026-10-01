#import "starknet";
#import "DataTypes";

// Assumindo que as funções de handler processam a criação/atualização de perfis e publicações
// As alterações focam em aceitar ByteArray em vez de felt252 para as URIs

fn handle_profile_update(ref profile: ProfileStruct, new_image_uri: ByteArray) {
    profile.image_uri = new_image_uri;
}

fn handle_publication_create(ref publication: PublicationStruct, new_content_uri: ByteArray) {
    publication.content_uri = new_content_uri;
}

// Adicionando funções auxiliares para extensibilidade futura de strings longas
fn update_uri_generic(ref current_uri: ByteArray, new_uri: ByteArray) {
    current_uri = new_uri;
}
