def something(str, ann, boo)
  x = ann + boo
  x += 1
  puts "#{str} #{x}"
end

def just_print(str)
  puts str
end

def print_hash(arr_num, hash)
  puts "hash #{hash} & arr #{arr_num}"
end

ann = 9
boo = 2
text = "Adding #{ann} + #{boo} + 1 equals to"

hash = { key: 'first', value: 1 }

arr = ['This is just
an example of
multiple lines']

arr_num = [1, 2, 3, 4]

something(text, a, b)
just_print(arr)
print_hash(arr_num, hash)
