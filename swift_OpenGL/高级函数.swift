
var fileteredArray : [Int] = [1,30,50,40,50,34,60,89]
let array = fileteredArray.filter{$0>30}
print(array)

let numbers = [1,2,3]
var sumNumbers = [Int]()
for var number in numbers {
	number += number
	sumNumbers.append(number)
}

print(sumNumbers)

let sumNumersa = sumNumbers.map{$0 + $0}

print(sumNumersa)

let fruits = ["apple","banana","orange",""]

let counts = fruits.map{ fruit -> Int? in
	let length = fruit.characters.count
	
	guard length > 0 else {
		return nil
	}
	return length
}

print(counts)

let countArray = [1,2,3,4,5,6]
print(countArray.map{$0%2 == 0})
print(countArray.filter{$0%2==0})

let eats = ["apple","banana","orange",""]

let eatcounts = eats.flatMap{ eat -> Int? in
	let length = eat.characters.count
	guard length > 0 else {
		return nil
	}
	return length
}
print(eatcounts)

let numarray = [[1,2,3],[4,5,6],[7,8,9]]

print(numarray.map{$0})

print(numarray.flatMap{$0})

let strarray = ["apple","banana","orange"]
let eatnum = [1,2,3]
let streat = eatnum.flatMap{ count in
	strarray.map{ fruit in 
		//title + ""
		(fruit,count)
	}
}
print(streat)

