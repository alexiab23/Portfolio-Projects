--start off with a greeting message
print("Hello" + "" + input("What is your name?") + " " + "thank you for using our Band Name generator!")

--Gather questions for the user to interact with 
city = input("What amazing city did you grow up in?\n")
pet = input("What is/will be the name of your lovely pet?\n")
color = input("What is your favorite color?\n")
vegetable = input("What is your favorite vegetable?\n")
fruit = input("What is your favorite fruit?\n") 

--Put everything together and create different combinations
print("Your band name could be:")
print(city + " " + pet)
print(city + " " + color)
print(city + " " + vegetable)
print(city + " " + fruit)
print(color + " " + pet)
print(vegetable + " " + pet)
print(vegetable + " " + fruit)
print(fruit + " " + color)
print(color + " " + vegetable)
print(city + " " + pet)
print(pet + " " + fruit)
print(fruit + " " + color)

-- The full code below is:

print("Hello" + " " + input("What is your name?") + " " + "thank you for using our Band Name generator!")
city = input("What amazing city did you grow up in?\n")
pet = input("What is/will be the name of your lovely pet?\n")
color = input("What is your favorite color?\n")
vegetable = input("What is your favorite vegetable?\n")
fruit = input("What is your favorite fruit?\n") 

print("Your band name could be:")
print(city + " " + pet)
print(city + " " + color)
print(city + " " + vegetable)
print(city + " " + fruit)
print(color + " " + pet)
print(vegetable + " " + pet)
print(vegetable + " " + fruit)
print(fruit + " " + color)
print(color + " " + vegetable)
print(city + " " + pet)
print(pet + " " + fruit)
print(fruit + " " + color)