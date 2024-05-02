expirationd = require('expirationd')
fiber = require('fiber')

box.schema.create_space('users', {
    format = {
        { name = 'id',               type = 'unsigned' },
        { name = 'bucket_id',        type = 'unsigned' },
        { name = 'balance',          type = 'double' },
        { name = 'rub_per_sec',      type = 'double' },
        { name = 'is_tracked',       type = 'boolean' },
        { name = 'last_update_time', type = 'double' },
    },
    if_not_exists = true
})

box.space.users:create_index('id', { parts = { 'id' }, if_not_exists = true })
box.space.users:create_index('bucket_id', { parts = { 'bucket_id' }, unique = false, if_not_exists = true })

function insert_user(id, bucket_id, balance, rub_per_sec, is_tracked)
    box.space.users:insert({ id, bucket_id, balance, rub_per_sec, is_tracked, fiber.time() })
end

function get_user(id)
    local tuple = box.space.users:get(id)
    if tuple == nil then
        return nil
    end
    return { tuple.id, tuple.balance, tuple.rub_per_sec, tuple.is_tracked, tuple.last_update_time }
end

function recalc_money(rub_per_sec, last_update_time)
    local money_spend = rub_per_sec * (fiber.time() - last_update_time)
    return money_spend
end

function change_user_last_update_time(id, time)
    box.space.users:update(id, { { '=', 6, time } })
    return true
end

function change_user_rub_per_sec(id, new_rub_per_sec)
    box.space.users:update(id, { { '=', 4, new_rub_per_sec } })
    change_user_last_update_time(id, fiber.time())
    return true
end

function change_user_balance(id, new_balance)
    box.space.users:update(id, { { '=', 3, new_balance } })
    change_user_last_update_time(id, fiber.time())
    return true
end

function add_user_balance(id, money)
    box.space.users:update(id, { { '+', 3, money } })
    change_user_last_update_time(id, fiber.time())
    return true
end

function change_user_is_tracked(id, is_tracked)
    box.space.users:update(id, { { '=', 5, is_tracked } })
    change_user_last_update_time(id, fiber.time())
    return true
end

function add_user_balance(id, money)
    local user = get_user(id)
    local new_balance = user[2] + money
    change_user_balance(id, new_balance)
    change_user_is_tracked(id, true)
    return true
end

function is_expired(args, tuple)
    if tuple.is_tracked == false then
        return false
    end
    local money_spend = recalc_money(tuple.rub_per_sec, tuple.last_update_time)
    if money_spend > tuple.balance then
        change_user_balance(tuple.id, 0.0)
        change_user_is_tracked(tuple.id, false)
        return true
    else
        change_user_balance(tuple.id, tuple.balance - money_spend)
        return false
    end
end

function delete_tuple(space, args, tuple)
    local user = tuple[2]
    change_user_rub_per_sec(user.id, 0)
    change_user_balance(user.id, 0)
    -- local http_client = require('http.client').new()
    -- http_client.request('GET', 'https://github.com/SuperCrabLover/MiptDBHW' .. tostring(user.id))
end

expirationd.start("clean_tuples", box.space.users.id, is_expired, {
    process_expired_tuple = delete_tuple,
    args = nil,
    tuples_per_iteration = 50,
    full_scan_time = 3600
})
