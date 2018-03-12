
let numbers = [1,2,3,4,5]
let sum = numbers.reduce(0) {$0 + $1}
print(sum)
let sum1 = numbers.reduce(0) { total, num in
	return total + num
}
print(sum1)

let numbers1 = [1,3,5,7,1,9,9,6,2,1,1]
let tel = numbers1.reduce("") { "\($0)" + "\($1)"}
print(tel)

extension Array {
	func mMap<U>(transform:Element ->U) -> [U] {
		return reduce([],combine:{$0 + [transform($1)]})
	}
	
	
}