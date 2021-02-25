number_to_convert = int(input("Please input number: "))
intToRoman = { 1: 'I', 4:'IV',5: 'V', 9:'IX', 10: 'X' , 40: 'XL', 50:'L',  90: 'XC', 100: 'C' , 400:'CD', 500: 'D' , 900: 'CM' , 1000: 'M'}
numbers = [ 1 , 4 , 5 , 9 , 10 , 40 , 50 , 90 , 100 , 400, 500 , 900, 1000]
while number_to_convert != 0:
  array = [i for i in numbers if i <= number_to_convert]
  print(intToRoman[array[-1]],end="")
  number_to_convert -= array[-1]
print("")
