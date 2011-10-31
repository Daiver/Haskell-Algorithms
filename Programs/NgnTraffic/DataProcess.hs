{-
/****************************************************************************
** NgnTrafficParser 2.0
** Copyright (C) 2011 Granin A.S.
** Contact: Granin A.S. (graninas@gmail.com)
**
** This file is part of NgnTrafficParser 2.0.
**
** GNU General Public License Usage
** This file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL3 included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/licenses/gpl.html.
**
** If you have questions regarding the use of this file, please contact
** author (graninas@gmail.com).
**
****************************************************************************/
-}

module DataProcess where

import Types
import qualified Data.ByteString.Char8 as C
import qualified Data.List as L (lookup, foldl')

import Constants


checkPredicate :: Predicate -> C.ByteString -> Bool
checkPredicate (NotInList l) str = (not . elem str) l
checkPredicate (InList l) str = elem str l

{-
examineFields :: Int -> PredicateMap -> Fields -> Bool
examineFields _ _ [] = True
examineFields idx preds (s:ss) = case L.lookup idx preds of
									Just pred -> (checkPredicate pred s) && (examineFields (idx+1) preds ss)
									Nothing -> examineFields (idx+1) preds ss
-}

examineFields :: PredicateMap -> Int -> Fields -> Bool
examineFields _ _ [] = False
examineFields ps maxF fs | maxF > length fs = False
						 | otherwise = let
											checkPred b (idx, pred) = b && checkPredicate pred (fs !! idx)
									   in L.foldl' checkPred True ps

{-
collectFields :: Int -> FieldIndexes -> Fields -> Fields
collectFields _ _ [] = []
collectFields idx fis (s:ss) | idx `elem` fis = s : collectFields (idx+1) fis ss
collectFields idx fis (s:ss) | otherwise = collectFields (idx+1) fis ss
-}

{-
-- ���� �������:
collectFields :: FieldIndexes -> Fields -> Fields
collectFields [] _ = []
collectFields (idx:xs) ss = [ss !! idx] ++ collectFields xs ss
-- �������� �����, ��� ������ �������:
-- foldr (\x list -> ss !! x : list) [] xs
-- �� ����� ������� �������� ����� �����, ���� ���� ���������� � �������� �������:
-- foldl (\list x -> ss !! x : list) [] xs
-}

collectFields :: FieldIndexes -> Fields -> Fields
collectFields [] _ = []
collectFields xs ss = reverse $ L.foldl' (\list x -> ss !! x : list) [] xs

processFields :: FieldIndexes -> PredicateMap -> Int -> Fields -> Fields
processFields fis preds maxF fs = case examineFields preds maxF fs of
									True -> collectFields fis fs
									False -> []

processLine :: FieldIndexes -> PredicateMap -> Int -> C.ByteString -> C.ByteString
processLine fis preds maxF = C.intercalate bsFieldDelimiter . processFields fis preds maxF . (C.split fieldDelimiter)

-- | ������������ ����� ������ � ���������� ������ � ������ �������.
processData :: FieldIndexes -> PredicateMap -> C.ByteString -> C.ByteString
processData fis preds = (C.unlines . filter (/= C.empty) . map (processLine fis preds maxPredicateField) . C.lines)

