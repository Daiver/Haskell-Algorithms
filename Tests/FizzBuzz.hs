{-
�������� ���������, ������� ������� �� ����� ����� �� 1 �� 100. ��� ���� ������ �����, ������� ����, ��������� ������ �������� ����� �Fizz�, � ������ �����, ������� ���� � ����� �Buzz�. ���� ����� ������ � 3, � 5, �� ��������� ������ �������� ����� �FizzBuzz�
-}


getOutput :: Int -> String
getOutput x | isDivided x 15 = "FizzBuzz"
			| isDivided x 5  = "Buzz"
			| isDivided x 3  = "Fizz"
			| otherwise      = show x
	where
		isDivided x n = (x `mod` n) == 0

main = do
		mapM_ (putStrLn . getOutput) [1..100]