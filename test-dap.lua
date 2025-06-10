local function test_sum(a, b)
  local result = a + b
  return result
end

local function main()
  local x = 5
  local y = 10
  local z = test_sum(x, y)
  print("Sum is:", z)
end

require("osv").suspend()

main()
main()
main()
main()
