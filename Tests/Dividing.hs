{-
�������� ���, ������� ������� ���������� �������� ����� n, �� ������� ��� ����� ������� ��� �������.

��� ����� n, �������� � ��� ����� �����, ������ �������� �������� ���������� ������ ����� n. � �������, ���� n ��������� 1938, �� ��� ���������� ����� ��������: 1, 9, 3, 8, 19, 93, 38, 193 � 938. ��� ������� 1938 ������� �� ������ �� ���� ��������: 1, 3, 19 � 38. ��������������, ����������� ������ ��������� ������ ���� ����� 4.
���� �������� �����������, ������ �� ��� ���������. ��������, 101 ������� ��� ������� �� 1, 1 � 01, ������, ����� � 3.
-}

import Data.List

dividedBy :: Int -> String -> Bool
dividedBy _ [] = False
dividedBy n b = case read b of
					0 -> False
					x -> n `mod` x == 0 && n /= x


sublists :: String -> [String]
sublists [] = []
sublists s@(c:cs) = takeSub s (length s) ++ sublists cs
    where
        takeSub _ 0 = []
        takeSub s count = take count s : takeSub s (count - 1)

dividers :: Int -> Int
dividers n = length . filter (dividedBy n) . sublists . show $ n

main = putStrLn . show . dividers $ 1938