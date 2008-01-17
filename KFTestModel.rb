#
#  KFTestModel.rb
#  kanaflash
#
#  Created by June Tate-Gans on 1/16/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class KFTestModel < OSX::NSObject
  class IllegalArgumentException < RuntimeError
  end

  KANA = { 
    :hiragana => ["あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ", "が", "ぎ", "ぐ", "げ", "ご", "さ", "し", "す", "せ", "そ", "ざ", "じ", "ず", "ぜ", "ぞ", "た", "ち", "つ", "て", "と", "だ", "じ", "ず", "で", "ど", "な", "に", "ぬ", "ね", "の", "は", "ひ", "ふ", "へ", "ほ", "ば", "び", "ぶ", "べ", "ぼ", "ぱ", "ぴ", "ぷ", "ぺ", "ぽ", "ま", "み", "む", "め", "も", "や", "ゆ", "よ", "ら", "り", "る", "れ", "ろ", "わ", "ん", "を"],
    :katakana => ["ア", "イ", "ウ", "エ", "オ", "カ", "キ", "ク", "ケ", "コ", "ガ", "ギ", "グ", "ゲ", "ゴ", "サ", "シ", "ス", "セ", "ソ", "ザ", "ジ", "ズ", "ゼ", "ゾ", "タ", "チ", "ツ", "テ", "ト", "ダ", "ジ", "ズ", "デ", "ド", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "ヒ", "フ", "ヘ", "ホ", "バ", "ビ", "ブ", "ベ", "ボ", "パ", "ピ", "プ", "ペ", "ポ", "マ", "ミ", "ム", "メ", "モ", "ヤ", "ユ", "ヨ", "ラ", "リ", "ル", "レ", "ロ", "ワ", "ん", "ヲ"],
    :romaji   => ["a", "i", "u", "e", "o", "ka", "ki", "ku", "ke", "ko", "ga", "gi", "gu", "ge", "go", "sa", "shi", "su", "se", "so", "za", "ji", "zu", "ze", "zo", "ta", "chi", "tsu", "te", "to", "da", "ji", "zu", "de", "do", "na", "ni", "nu", "ne", "no", "ha", "hi", "fu", "he", "ho", "ba", "bi", "bu", "be", "bo", "pa", "pi", "pu", "pe", "po", "ma", "mi", "mu", "me", "mo", "ya", "yu", "yo", "ra", "ri", "ru", "re", "ro", "wa", "n", "wo"]
  }       
  
  def initialize
    Kernel.srand(Time.now.usec)
    reset!
  end

  def numCorrect
    return @num_correct
  end

  def numIncorrect
    return @num_incorrect
  end

  def numQuestions
    return numCorrect + numIncorrect
  end

  def accuracyPercentage
    begin
      result = numCorrect / numQuestions
    rescue ZeroDivisionError => e
      return 0
    else
      return result
    end
  end

  def generateNextQuestion!
    @cached_answer = Kernel.rand(KANA[@kana].length)
  end

  def checkAnswer!(answer)
    if KANA[:romaji][@cached_answer] == answer
      @num_correct += 1
      return true
    else
      @num_incorrect += 1
      return false
    end
  end

  def answer
    return KANA[:romaji][@cached_answer]
  end

  def question
    return KANA[@kana][@cached_answer]
  end

  def setKanaType(type)
    if KANA.keys.include? type
      @kana = type
    else
      raise IllegalArgumentException, "Type #{type.to_s} is not a valid kana type."
    end
  end

  def getKanaTypes
    return KANA.keys
  end

  def reset!
    @num_correct = 0
    @num_incorrect = 0
    @kana = :hiragana

    generateNextQuestion!
  end
end
