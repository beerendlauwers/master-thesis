
function MetadataCartJS() { }
MetadataCartJS._path = '/dwr';

MetadataCartJS.addToCart = function(p0, callback) {
    DWREngine._execute(MetadataCartJS._path, 'MetadataCartJS', 'addToCart', p0, callback);
}

MetadataCartJS.addToCart = function(p1, callback) {
    DWREngine._execute(MetadataCartJS._path, 'MetadataCartJS', 'addToCart', false, p1, callback);
}

MetadataCartJS.removeFromCart = function(p0, callback) {
    DWREngine._execute(MetadataCartJS._path, 'MetadataCartJS', 'removeFromCart', p0, callback);
}

MetadataCartJS.removeFromCart = function(p1, callback) {
    DWREngine._execute(MetadataCartJS._path, 'MetadataCartJS', 'removeFromCart', false, p1, callback);
}
