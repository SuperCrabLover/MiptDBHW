local vshard = require('vshard')
function put(id, balance, rub_per_sec)
    local bucket_id = vshard.router.bucket_id_mpcrc32({ id })
    vshard.router.callrw(bucket_id, 'insert_user', { id, bucket_id, balance, rub_per_sec })
end
function get(id)
    local bucket_id = vshard.router.bucket_id_mpcrc32({ id })
    return vshard.router.callro(bucket_id, 'get_user', { id })
end
function insert_data()
    put(1, 1000, 0.001)
    put(2, 100, 1)
    put(3, 1.5, 0.5)
end
