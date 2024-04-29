box.schema.create_space('users', {
    format = {
        { name = 'id', type = 'unsigned' },
        { name = 'bucket_id', type = 'unsigned' },
        { name = 'balance', type = 'double' },
        { name = 'rub_per_sec', type = 'double' }
    },
    if_not_exists = true
})
box.space.users:create_index('id', { parts = { 'id' }, if_not_exists = true })
box.space.users:create_index('bucket_id', { parts = { 'bucket_id' }, unique = false, if_not_exists = true })
function insert_user(id, bucket_id, balance, rub_per_sec)
    box.space.users:insert({ id, bucket_id, balance, rub_per_sec })
end
function get_user(id)
    local tuple = box.space.users:get(id)
    if tuple == nil then
        return nil
    end
    return { tuple.id, tuple.balance, tuple.rub_per_sec }
end
function add_user_balance(id, money)
    box.space.users:update(id, {{'+', 3, money}})
    return true
end
function change_user_rub_per_sec(id, new_rub_per_sec)
    box.space.users:update(id, {{'=', 4, new_rub_per_sec}})
    return true
end
