#
#  KFWindowController.rb
#  kanaflash
#
#  Created by June Tate-Gans on 1/16/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class KFWindowController < OSX::NSWindowController
  ib_outlet :questionView
  ib_outlet :totalCorrectText
  ib_outlet :totalIncorrectText
  ib_outlet :totalText
  ib_outlet :elapsedTimeText
  ib_outlet :answerTextField

  KANA = { 
    :hiragana => ["あ", "い", "う", "え", "お", "か", "き", "く", "け", "こ", "が", "ぎ", "ぐ", "げ", "ご", "さ", "し", "す", "せ", "そ", "ざ", "じ", "ず", "ぜ", "ぞ", "た", "ち", "つ", "て", "と", "だ", "じ", "ず", "で", "ど", "な", "に", "ぬ", "ね", "の", "は", "ひ", "ふ", "へ", "ほ", "ば", "び", "ぶ", "べ", "ぼ", "ぱ", "ぴ", "ぷ", "ぺ", "ぽ", "ま", "み", "む", "め", "も", "や", "ゆ", "よ", "ら", "り", "る", "れ", "ろ", "わ", "ん", "を"],
    :katakana => ["ア", "イ", "ウ", "エ", "オ", "カ", "キ", "ク", "ケ", "コ", "ガ", "ギ", "グ", "ゲ", "ゴ", "サ", "シ", "ス", "セ", "ソ", "ザ", "ジ", "ズ", "ゼ", "ゾ", "タ", "チ", "ツ", "テ", "ト", "ダ", "ジ", "ズ", "デ", "ド", "ナ", "ニ", "ヌ", "ネ", "ノ", "ハ", "ヒ", "フ", "ヘ", "ホ", "バ", "ビ", "ブ", "ベ", "ボ", "パ", "ピ", "プ", "ペ", "ポ", "マ", "ミ", "ム", "メ", "モ", "ヤ", "ユ", "ヨ", "ラ", "リ", "ル", "レ", "ロ", "ワ", "ん", "ヲ"],
    :romaji   => ["a", "i", "u", "e", "o", "ka", "ki", "ku", "ke", "ko", "ga", "gi", "gu", "ge", "go", "sa", "shi", "su", "se", "so", "za", "ji", "zu", "ze", "zo", "ta", "chi", "tsu", "te", "to", "da", "ji", "zu", "de", "do", "na", "ni", "nu", "ne", "no", "ha", "hi", "fu", "he", "ho", "ba", "bi", "bu", "be", "bo", "pa", "pi", "pu", "pe", "po", "ma", "mi", "mu", "me", "mo", "ya", "yu", "yo", "ra", "ri", "ru", "re", "ro", "wa", "n", "wo"]
  }       
  
  def awakeFromNib
    Kernel.srand(Time.now.usec)
    @mode = :hiragana
    
    @questionView.setEditable(false);

    resetTest nil
  end
  
  def updateStats
    @totalCorrectText.takeIntValueFrom(@num_correct)
    @totalIncorrectText.takeIntValueFrom(@num_incorrect)
    @totalText.takeIntValueFrom(@num_total)
  end
  
  def updateQuestion
    @questionView.setStringValue(KANA[@mode][@cached_answer])
  end

  def cacheNextAnswer
    return Kernel.rand(KANA[@mode].length)
  end

  def resetTest(sender)
    @cached_answer = cacheNextAnswer
    @num_correct = 0
    @num_incorrect = 0
    @num_total = 0
    @test_start = Time.now
    @elapsed_seconds = 0
    @mode = :hiragana

    updateStats
    updateQuestion
  end
  ib_action :resetTest

  def checkAnswer(sender)
    if @answerTextField.stringValue == KANA[:romaji][@cached_answer]
      NSRunAlertPanel("KanaFlash", "Correct!", 'OK', nil, nil)
      @num_correct += 1
    else
      NSRunAlertPanel("KanaFlash", "Incorrect! Correct answer was #{KANA[:romaji][@cached_answer]}.", 'OK', nil, nil)
      @num_incorrect += 1
    end
    
    @num_total += 1
    @cached_answer = cacheNextAnswer

    updateStats
    updateQuestion
  end
  ib_action :checkAnswer
end
