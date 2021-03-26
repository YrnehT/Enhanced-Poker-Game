defmodule Poker do
	def deal(list) do
		set1 = [Enum.at(list, 0), Enum.at(list, 2), Enum.at(list, 4), Enum.at(list, 5), Enum.at(list, 6), Enum.at(list, 7), Enum.at(list, 8)]
		set2 = [Enum.at(list, 1), Enum.at(list, 3), Enum.at(list, 4), Enum.at(list, 5), Enum.at(list, 6), Enum.at(list, 7), Enum.at(list, 8)]
		possibleHands1 = possibleHands(set1)
		possibleHands2 = possibleHands(set2)
		bestHand1 = playerBestHand(possibleHands1)
		bestHand2 = playerBestHand(possibleHands2)
		maxValue1 = checkHand(bestHand1)
		maxValue2 = checkHand(bestHand2)
		bestHand = compareHand(bestHand1, bestHand2, maxValue1, maxValue2)
		result = Enum.sort(Enum.map(bestHand, fn x -> transformCard(x) end))
		result
	end
	
	
	# Functions to check for the type of hand
	def isRoyalFlush(hand) do
		isAhigh(hand) && isKhigh(hand) && isFlush(hand) && isStraight(hand)
	end
	
	def isStraightFlush(hand) do
		isFlush(hand) && isStraight(hand)
	end	
	
	def isFourOfAKind(hand) do 
		Enum.member?(count(hand), 4)
	end
	
	def isFullHouse(hand) do
		arrayCounter = count(hand)
		Enum.member?(arrayCounter, 3) && Enum.member?(arrayCounter, 2)
	end
	
	def isFlush(hand) do 
		sortedHand = Enum.sort(hand)
		last = List.last(sortedHand)
		cond do 
			last <= 13 -> true
			last <= 26 -> Enum.all?(hand, fn x -> x > 13 end) 
			last <= 39 -> Enum.all?(hand, fn x -> x > 26 end)
			last <= 52 -> Enum.all?(hand, fn x -> x > 39 end)
		end
	end
	
	def isStraight(hand) do
		check = countCompare(hand)
		card1 = Enum.at(check, 0)
		card2 = Enum.at(check, 1)
		card3 = Enum.at(check, 2)
		card4 = Enum.at(check, 3)
		card5 = Enum.at(check, 4)
		cond do
			card1 == 1 && card5 == 13 -> (card2 == 10 && card3 == 11 && card4 == 12)
			true -> ((card2 - card1 == 1) && (card3 - card2 == 1) && (card4 - card3 == 1) && (card5 - card4 == 1))
		end
	end
	
	def isThreeOfAKind(hand) do
		Enum.member?(count(hand), 3)
	end
	
	def isTwoPairs(hand) do
		arrayCounter = count(hand)
		(Enum.count(arrayCounter, fn x -> x == 2 end)) == 2
	end
	
	def isPair(hand) do
		Enum.member?(count(hand), 2)
	end
	
	def isAhigh(hand) do
		Enum.any?(hand, fn x -> x == 1 || x == 14 || x == 27 || x == 40 end)
	end
	
	def isKhigh(hand) do
		Enum.any?(hand, fn x -> x == 13 || x == 26 || x == 39 || x == 52 end)
	end
	
	def isQhigh(hand) do
		Enum.any?(hand, fn x -> x == 12 || x == 25 || x == 38 || x == 51 end)
	end
	
	def isJhigh(hand) do
		Enum.any?(hand, fn x -> x == 11 || x == 24 || x == 37 || x == 50 end)
	end
	
	def is10high(hand) do
		Enum.any?(hand, fn x -> x == 10 || x == 23 || x == 36 || x == 49 end)
	end
	
	def is9high(hand) do
		Enum.any?(hand, fn x -> x == 9 || x == 22 || x == 35 || x == 48 end)
	end
	
	def is8high(hand) do
		Enum.any?(hand, fn x -> x == 8 || x == 21 || x == 34 || x == 47 end)
	end
	
	def is7high(hand) do
		Enum.any?(hand, fn x -> x == 7 || x == 20 || x == 33 || x == 46 end)
	end
	
	def is6high(hand) do
		Enum.any?(hand, fn x -> x == 6 || x == 19 || x == 32 || x == 45 end)
	end
	
	def is5high(hand) do
		Enum.any?(hand, fn x -> x == 5 || x == 18 || x == 31 || x == 44 end)
	end
	
	def is4high(hand) do
		Enum.any?(hand, fn x -> x == 4 || x == 17 || x == 30 || x == 43 end)
	end
	
	def is3high(hand) do
		Enum.any?(hand, fn x -> x == 3 || x == 16 || x == 29 || x == 42 end)
	end
	
	def is2high(hand) do
		Enum.any?(hand, fn x -> x == 2 || x == 15 || x == 28 || x == 41 end)
	end
	
	# Support function to count 
	def countCompare(hand) do
		card1 = List.first(hand)
		card2 = hd(tl(hand))
		card3 = hd(tl(tl(hand)))
		card4 =	hd(tl(tl(tl(hand))))
		card5 = List.last(hand)
		
		value1 = countCompareSupport(card1)
		value2 = countCompareSupport(card2)
		value3 = countCompareSupport(card3)
		value4 = countCompareSupport(card4)
		value5 = countCompareSupport(card5)
		
		result = Enum.sort([value1, value2, value3, value4, value5])
		result
	end
	
	def countCompareSupport(card) do
		ace = [1, 14, 27, 40]
		two = [2, 15, 28, 41]
		three = [3, 16, 29, 42]
		four = [4, 17, 30, 43]
		five = [5, 18, 31, 44]
		six = [6, 19, 32, 45]
		seven = [7, 20, 33, 46]
		eight = [8, 21, 34, 47]
		nine = [9, 22, 35, 48]
		ten = [10, 23, 36, 49]
		jack = [11, 24, 37, 50]
		queen = [12, 25, 38, 51]
		king = [13, 26, 39, 52]
		
		cond do
			Enum.member?(ace, card) == true -> 1
			Enum.member?(two, card) == true -> 2
			Enum.member?(three, card) == true -> 3
			Enum.member?(four, card) == true -> 4
			Enum.member?(five, card) == true -> 5
			Enum.member?(six, card) == true -> 6
			Enum.member?(seven, card) == true -> 7
			Enum.member?(eight, card) == true -> 8
			Enum.member?(nine, card) == true -> 9
			Enum.member?(ten, card) == true -> 10
			Enum.member?(jack, card) == true -> 11
			Enum.member?(queen, card) == true -> 12
			Enum.member?(king, card) == true -> 13
		end
	end
	
	def count(hand) do
		countA = Enum.count(hand, fn x -> x == 1 || x == 14 || x == 27 || x == 40 end) 
		count2 = Enum.count(hand, fn x -> x == 2 || x == 15 || x == 28 || x == 41 end)
		count3 = Enum.count(hand, fn x -> x == 3 || x == 16 || x == 29 || x == 42 end)
		count4 = Enum.count(hand, fn x -> x == 4 || x == 17 || x == 30 || x == 43 end)
		count5 = Enum.count(hand, fn x -> x == 5 || x == 18 || x == 31 || x == 44 end)
		count6 = Enum.count(hand, fn x -> x == 6 || x == 19 || x == 32 || x == 45 end)
		count7 = Enum.count(hand, fn x -> x == 7 || x == 20 || x == 33 || x == 46 end)
		count8 = Enum.count(hand, fn x -> x == 8 || x == 21 || x == 34 || x == 47 end)
		count9 = Enum.count(hand, fn x -> x == 9 || x == 22 || x == 35 || x == 48 end)
		count10 = Enum.count(hand, fn x -> x == 10 || x == 23 || x == 36 || x == 49 end)
		countJ = Enum.count(hand, fn x -> x == 11 || x == 24 || x == 37 || x == 50 end)
		countQ = Enum.count(hand, fn x -> x == 12 || x == 25 || x == 38 || x == 51 end)
		countK = Enum.count(hand, fn x -> x == 13 || x == 26 || x == 39 || x == 52 end)
		result = [countA, count2, count3, count4, count5, count6, count7, count8, count9, count10, countJ, countQ, countK]
		result
	end
	
	def checkHand(hand) do
		cond do
			isRoyalFlush(hand) == true -> 10
			isStraightFlush(hand) == true -> 9
			isFourOfAKind(hand) == true -> 8
			isFullHouse(hand) == true -> 7
			isFlush(hand) == true -> 6
			isStraight(hand) == true -> 5
			isThreeOfAKind(hand) == true -> 4
			isTwoPairs(hand) == true -> 3
			isPair(hand) == true -> 2
			true -> 1
		end
	end
	
	def compareSameHand(hand1, hand2) do
		handValue = checkHand(hand1)
		arrayCountCompare1 = countCompare(hand1)
		arrayCountCompare2 = countCompare(hand2)
		arrayCount1 = count(hand1)
		arrayCount2 = count(hand2)
		cond do
			handValue == 9 -> compareStraightFlush(hand1, hand2, arrayCountCompare1, arrayCountCompare2)
			handValue == 8 -> compareFourOfAKind(hand1, hand2, arrayCount1, arrayCount2)
			handValue == 7 -> compareFullHouse(hand1, hand2, arrayCount1, arrayCount2)
			handValue == 6 -> compareFlush(hand1, hand2, arrayCountCompare1, arrayCountCompare2)
			handValue == 5 -> compareStraight(hand1, hand2, arrayCountCompare1, arrayCountCompare2)
			handValue == 4 -> compareThreeOfAKind(hand1, hand2, arrayCount1, arrayCount2)
			handValue == 3 -> compareTwoPair(hand1, hand2, arrayCount1, arrayCount2)
			handValue == 2 -> comparePair(hand1, hand2, arrayCount1, arrayCount2)
			handValue == 1 -> compareHigh(hand1, hand2, arrayCountCompare1, arrayCountCompare2)
		end
	end
	
	def compareStraightFlush(hand1, hand2, arrayCountCompare1, arrayCountCompare2) do
		maxHand1 = Enum.at(arrayCountCompare1, 4)
		maxHand2 = Enum.at(arrayCountCompare2, 4)
		cond do
			maxHand1 > maxHand2 -> hand1
			true -> hand2
		end
	end
	
	def compareFourOfAKind(hand1, hand2, arrayCount1, arrayCount2) do
		maxHand1 = Enum.find_index(arrayCount1, fn x -> x == 4 end)
		maxHand2 = Enum.find_index(arrayCount2, fn x -> x == 4 end)
		cond do
			maxHand1 == 0 && maxHand2 != 0 -> hand1
			maxHand2 == 0 && maxHand1 != 0 -> hand2
			maxHand1 > maxHand2 -> hand1
			maxHand1 < maxHand2 -> hand2
			maxHand1 = maxHand2 -> 
				maxHand1 = Enum.find_index(arrayCount1, fn x -> x == 1 end)
				maxHand2 = Enum.find_index(arrayCount2, fn x -> x == 1 end)
				cond do
					maxHand1 == 0 && maxHand2 != 0 -> hand1
					maxHand2 == 0 && maxHand1 != 0 -> hand2
					maxHand1 > maxHand2 -> hand1
					true -> hand2
				end
		end
	end
	
	def compareFullHouse(hand1, hand2, arrayCount1, arrayCount2) do
		maxHand1 = Enum.find_index(arrayCount1, fn x -> x == 3 end)
		maxHand2 = Enum.find_index(arrayCount2, fn x -> x == 3 end)
		cond do
			maxHand1 == 0 && maxHand2 != 0 -> hand1
			maxHand2 == 0 && maxHand1 != 0 -> hand2
			maxHand1 > maxHand2 -> hand1
			maxHand1 < maxHand2 -> hand2
			maxHand1 = maxHand2 -> 
				maxHand1 = Enum.find_index(arrayCount1, fn x -> x == 2 end)
				maxHand2 = Enum.find_index(arrayCount2, fn x -> x == 2 end)
				cond do
					maxHand1 == 0 && maxHand2 != 0 -> hand1
					maxHand2 == 0 && maxHand1 != 0 -> hand2
					maxHand1 > maxHand2 -> hand1
					true -> hand2
				end
		end
	end
	
	def compareFlush(hand1, hand2, arrayCountCompare1, arrayCountCompare2) do
		maxHand1 = Enum.at(arrayCountCompare1, 0)
		maxHand2 = Enum.at(arrayCountCompare2, 0)
		cond do
			maxHand1 == 1 && maxHand2 != 1 -> hand1
			maxHand2 == 1 && maxHand1 != 1 -> hand2
			true ->
				maxHand1 = Enum.at(arrayCountCompare1, 4)
				maxHand2 = Enum.at(arrayCountCompare2, 4)
				cond do
					maxHand1 > maxHand2 -> hand1
					maxHand1 < maxHand2 -> hand2
					maxHand1 = maxHand2 ->
						maxHand1 = Enum.at(arrayCountCompare1, 3)
						maxHand2 = Enum.at(arrayCountCompare2, 3)
						cond do
							maxHand1 > maxHand2 -> hand1
							maxHand1 < maxHand2 -> hand2
							maxHand1 = maxHand2 ->
								maxHand1 = Enum.at(arrayCountCompare1, 2)
								maxHand2 = Enum.at(arrayCountCompare2, 2)
								cond do
									maxHand1 > maxHand2 -> hand1
									maxHand1 < maxHand2 -> hand2
									maxHand1 = maxHand2 ->
										maxHand1 = Enum.at(arrayCountCompare1, 1)
										maxHand2 = Enum.at(arrayCountCompare2, 1)
										cond do
											maxHand1 > maxHand2 -> hand1
											maxHand1 < maxHand2 -> hand2
											maxHand1 = maxHand2 ->
												maxHand1 = Enum.at(arrayCountCompare1, 0)
												maxHand2 = Enum.at(arrayCountCompare2, 0)
												cond do
													maxHand1 > maxHand2 -> hand1
													true -> hand2
												end
										end
								end
						end
				end
		end
	end
	
	def compareStraight(hand1, hand2, arrayCountCompare1, arrayCountCompare2) do
		maxHand1 = Enum.at(arrayCountCompare1, 4)
		maxHand2 = Enum.at(arrayCountCompare2, 4)
		cond do
			maxHand1 == 13 && Enum.at(arrayCountCompare1, 0) == 1 -> hand1
			maxHand2 == 13 && Enum.at(arrayCountCompare2, 0) == 1 -> hand2
			maxHand1 > maxHand2 -> hand1
			true -> hand2
		end
	end
	
	def compareThreeOfAKind(hand1, hand2, arrayCount1, arrayCount2) do
		maxHand1 = Enum.find_index(arrayCount1, fn x -> x == 3 end)
		maxHand2 = Enum.find_index(arrayCount2, fn x -> x == 3 end)
		cond do
			maxHand1 == 0 && maxHand2 != 0 -> hand1
			maxHand2 == 0 && maxHand1 != 0 -> hand2
			maxHand1 > maxHand2 -> hand1
			maxHand1 < maxHand2 -> hand2 
			maxHand1 = maxHand2 ->
				kicker = kickerGenerate(hand1, hand2, arrayCount1, arrayCount2, 1)
				maxHand1 = Enum.at(kicker, 0)
				maxHand2 = Enum.at(kicker, 2)
				cond do
					maxHand1 == 0 && maxHand2 != 0 -> hand1
					maxHand2 == 0 && maxHand1 != 0 -> hand2
					true ->
						maxHand1 = Enum.at(kicker, 1)
						maxHand2 = Enum.at(kicker, 3)
						cond do
							maxHand1 > maxHand2 -> hand1
							maxHand1 < maxHand2 -> hand2
							maxHand1 = maxHand2 ->
								maxHand1 = Enum.at(kicker, 0)
								maxHand2 = Enum.at(kicker, 2)
								cond do
									maxHand1 > maxHand2 -> hand1
									true -> hand2
								end
						end
				end
		end
	end
	
	def compareTwoPair(hand1, hand2, arrayCount1, arrayCount2) do
		kicker1 = kickerGenerate(hand1, hand2, arrayCount1, arrayCount2, 2)
		kicker2 = kickerGenerate(hand1, hand2, arrayCount1, arrayCount2, 1)
		maxHand1 = Enum.at(kicker1, 0)
		maxHand2 = Enum.at(kicker1, 2)
		cond do
			maxHand1 == 0 && maxHand2 != 0 -> hand1
			maxHand2 == 0 && maxHand1 != 0 -> hand2
			true ->
				maxHand1 = Enum.at(kicker1, 1)
				maxHand2 = Enum.at(kicker1, 3)
				cond do
					maxHand1 > maxHand2 -> hand1
					maxHand1 < maxHand2 -> hand2
					maxHand1 = maxHand2 ->
						maxHand1 = Enum.at(kicker1, 0)
						maxHand2 = Enum.at(kicker1, 2)
						cond do
							maxHand1 > maxHand2 -> hand1
							maxHand1 < maxHand2 -> hand2
							maxHand1 = maxHand2 ->
								maxHand1 = Enum.at(kicker2, 0)
								maxHand2 = Enum.at(kicker2, 1)
								cond do
									maxHand1 == 0 && maxHand2 != 0 -> hand1
									maxHand2 == 0 && maxHand2 != 0 -> hand2
									maxHand1 > maxHand2 -> hand1
									true -> hand2
								end
						end
				end
		end
	end
	
	def comparePair(hand1, hand2, arrayCount1, arrayCount2) do
		maxHand1 = Enum.find_index(arrayCount1, fn x -> x == 2 end)
		maxHand2 = Enum.find_index(arrayCount2, fn x -> x == 2 end)
		cond do
			maxHand1 == 0 && maxHand2 != 0 -> hand1
			maxHand2 == 0 && maxHand1 != 0 -> hand2
			maxHand1 > maxHand2 -> hand1
			maxHand1 < maxHand2 -> hand2 
			maxHand1 = maxHand2 ->
				kicker = kickerGenerate(hand1, hand2, arrayCount1, arrayCount2, 1)
				maxHand1 = Enum.at(kicker, 0)
				maxHand2 = Enum.at(kicker, 3)
				cond do
					maxHand1 == 0 && maxHand2 != 0 -> hand1
					maxHand2 == 0 && maxHand1 != 0 -> hand2
					true ->
						maxHand1 = Enum.at(kicker, 2)
						maxHand2 = Enum.at(kicker, 5)
						cond do
							maxHand1 > maxHand2 -> hand1
							maxHand1 < maxHand2 -> hand2
							maxHand1 = maxHand2 ->
								maxHand1 = Enum.at(kicker, 1)
								maxHand2 = Enum.at(kicker, 4)
								cond do
									maxHand1 > maxHand2 -> hand1
									maxHand1 < maxHand2 -> hand2
									maxHand1 = maxHand2 -> 
										maxHand1 = Enum.at(kicker, 0)
										maxHand2 = Enum.at(kicker, 3)
										cond do
											maxHand1 > maxHand2 -> hand1
											true -> hand2
										end
								end
						end
				end
		end
	end
	
	def compareHigh(hand1, hand2, arrayCountCompare1, arrayCountCompare2) do
		compareFlush(hand1, hand2, arrayCountCompare1, arrayCountCompare2)
	end
	
	def kickerGenerate(hand1, hand2, arrayCount1, arrayCount2, value) do
		kicker1 = kickerSupport(arrayCount1, value)
		kicker2 = kickerSupport(arrayCount2, value)
		kicker = kicker1 ++ kicker2
		kicker
	end
	
	# Recursive function supporting the kickerGenerate
	def kickerSupport(data, value), do: kickerSupport(data, value, [], 0)
	def kickerSupport([], value, index, _), do: index
	def kickerSupport(data, value, index, total), do: (if hd(data) == value, do: kickerSupport(tl(data), value, index = index ++ [total], total = total+1), else: kickerSupport(tl(data), value, index, total = total+1))
	
	# Recursive functions to generate all possible combinations
	def comb(0, _), do: [[]]
	def comb(_, []), do: []
	def comb(m, [h|t]) do
		(for l <- comb(m-1, t), do: [h|l]) ++ comb(m, t)
	end
	
	def possibleHands(hand7cards) do
		result = comb(5, hand7cards)
		result
	end
	
	def playerBestHand(sequence) do
		hand1 = Enum.at(sequence, 0)
		hand2 = Enum.at(sequence, 1)
		hand3 = Enum.at(sequence, 2)
		hand4 = Enum.at(sequence, 3)
		hand5 = Enum.at(sequence, 4)
		hand6 = Enum.at(sequence, 5)
		hand7 = Enum.at(sequence, 6)
		hand8 = Enum.at(sequence, 7)
		hand9 = Enum.at(sequence, 8)
		hand10 = Enum.at(sequence, 9)
		hand11 = Enum.at(sequence, 10)
		hand12 = Enum.at(sequence, 11)
		hand13 = Enum.at(sequence, 12)
		hand14 = Enum.at(sequence, 13)
		hand15 = Enum.at(sequence, 14)
		hand16 = Enum.at(sequence, 15)
		hand17 = Enum.at(sequence, 16)
		hand18 = Enum.at(sequence, 17)
		hand19 = Enum.at(sequence, 18)
		hand20 = Enum.at(sequence, 19)
		hand21 = Enum.at(sequence, 20)
		
		handValue1 = checkHand(hand1)
		handValue2 = checkHand(hand2)
		handValue3 = checkHand(hand3)
		handValue4 = checkHand(hand4)
		handValue5 = checkHand(hand5)
		handValue6 = checkHand(hand6)
		handValue7 = checkHand(hand7)
		handValue8 = checkHand(hand8)
		handValue9 = checkHand(hand9)
		handValue10 = checkHand(hand10)
		handValue11 = checkHand(hand11)
		handValue12 = checkHand(hand12)
		handValue13 = checkHand(hand13)
		handValue14 = checkHand(hand14)
		handValue15 = checkHand(hand15)
		handValue16 = checkHand(hand16)
		handValue17 = checkHand(hand17)
		handValue18 = checkHand(hand18)
		handValue19 = checkHand(hand19)
		handValue20 = checkHand(hand20)
		handValue21 = checkHand(hand21)
		
		handList = [hand1, hand2, hand3, hand4, hand5, hand6, hand7, hand8, hand9, hand10, hand11, hand12, hand13, hand14, hand15, hand16, hand17, hand18,
		hand19, hand20, hand21]
		
		handValueList = [handValue1, handValue2, handValue3, handValue4, handValue5, handValue6, handValue7, handValue8, handValue9, handValue10, 
		handValue11, handValue12, handValue13, handValue14, handValue15, handValue16, handValue17, handValue18, handValue19, handValue20, handValue21]
		
		maxValue = handValue1
		maxHand = hand1
		
		maxValue = compareValue(maxValue, handValue2)
		maxHand = compareHand(maxHand, hand2, checkHand(maxHand), handValue2)
		
		maxValue = compareValue(maxValue, handValue3)
		maxHand = compareHand(maxHand, hand3, checkHand(maxHand), handValue3)
		
		maxValue = compareValue(maxValue, handValue4)
		maxHand = compareHand(maxHand, hand4, checkHand(maxHand), handValue4)
		
		maxValue = compareValue(maxValue, handValue5)
		maxHand = compareHand(maxHand, hand5, checkHand(maxHand), handValue5)
		
		maxValue = compareValue(maxValue, handValue6)
		maxHand = compareHand(maxHand, hand6, checkHand(maxHand), handValue6)
		
		maxValue = compareValue(maxValue, handValue7)
		maxHand = compareHand(maxHand, hand7, checkHand(maxHand), handValue7)
		
		maxValue = compareValue(maxValue, handValue8)
		maxHand = compareHand(maxHand, hand8, checkHand(maxHand), handValue8)
		
		maxValue = compareValue(maxValue, handValue9)
		maxHand = compareHand(maxHand, hand9, checkHand(maxHand), handValue9)
		
		maxValue = compareValue(maxValue, handValue10)
		maxHand = compareHand(maxHand, hand10, checkHand(maxHand), handValue10)
		
		maxValue = compareValue(maxValue, handValue11)
		maxHand = compareHand(maxHand, hand11, checkHand(maxHand), handValue11)
		
		maxValue = compareValue(maxValue, handValue12)
		maxHand = compareHand(maxHand, hand12, checkHand(maxHand), handValue12)
		
		maxValue = compareValue(maxValue, handValue13)
		maxHand = compareHand(maxHand, hand13, checkHand(maxHand), handValue13)
		
		maxValue = compareValue(maxValue, handValue14)
		maxHand = compareHand(maxHand, hand14, checkHand(maxHand), handValue14)
		
		maxValue = compareValue(maxValue, handValue15)
		maxHand = compareHand(maxHand, hand15, checkHand(maxHand), handValue15)
		
		maxValue = compareValue(maxValue, handValue16)
		maxHand = compareHand(maxHand, hand16, checkHand(maxHand), handValue16)
		
		maxValue = compareValue(maxValue, handValue17)
		maxHand = compareHand(maxHand, hand17, checkHand(maxHand), handValue17)
		
		maxValue = compareValue(maxValue, handValue18)
		maxHand = compareHand(maxHand, hand18, checkHand(maxHand), handValue18)
		
		maxValue = compareValue(maxValue, handValue19)
		maxHand = compareHand(maxHand, hand19, checkHand(maxHand), handValue19)
		
		maxValue = compareValue(maxValue, handValue20)
		maxHand = compareHand(maxHand, hand20, checkHand(maxHand), handValue20)
		
		maxValue = compareValue(maxValue, handValue21)
		maxHand = compareHand(maxHand, hand21, checkHand(maxHand), handValue21)
		
		maxHand
	end
	
	def compareValue(firstVal, secondVal) do
		cond do 
			firstVal >= secondVal -> firstVal
			firstVal < secondVal -> secondVal
		end
	end
	
	def compareHand(firstHand, secondHand, firstVal, secondVal) do
		cond do
			firstVal > secondVal -> firstHand
			firstVal < secondVal -> secondHand
			firstVal = secondVal -> compareSameHand(firstHand, secondHand)
		end
	end
	
	def transformCard(card) do
		cond do
			card == 1 -> "1C"
			card == 2 -> "2C"
			card == 3 -> "3C"
			card == 4 -> "4C"
			card == 5 -> "5C"
			card == 6 -> "6C"
			card == 7 -> "7C"
			card == 8 -> "8C"
			card == 9 -> "9C"
			card == 10 -> "10C"
			card == 11 -> "11C"
			card == 12 -> "12C"
			card == 13 -> "13C"
			card == 14 -> "1D"
			card == 15 -> "2D"
			card == 16 -> "3D"
			card == 17 -> "4D"
			card == 18 -> "5D"
			card == 19 -> "6D"
			card == 20 -> "7D"
			card == 21 -> "8D"
			card == 22 -> "9D"
			card == 23 -> "10D"
			card == 24 -> "11D"
			card == 25 -> "12D"
			card == 26 -> "13D"
			card == 27 -> "1H"
			card == 28 -> "2H"
			card == 29 -> "3H"
			card == 30 -> "4H"
			card == 31 -> "5H"
			card == 32 -> "6H"
			card == 33 -> "7H"
			card == 34 -> "8H"
			card == 35 -> "9H"
			card == 36 -> "10H"
			card == 37 -> "11H"
			card == 38 -> "12H"
			card == 39 -> "13H"
			card == 40 -> "1S"
			card == 41 -> "2S"
			card == 42 -> "3S"
			card == 43 -> "4S"
			card == 44 -> "5S"
			card == 45 -> "6S"
			card == 46 -> "7S"
			card == 47 -> "8S"
			card == 48 -> "9S"
			card == 49 -> "10S"
			card == 50 -> "11S"
			card == 51 -> "12S"
			card == 52 -> "13S"
		end
	end
end
