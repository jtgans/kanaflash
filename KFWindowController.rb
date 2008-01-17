#
#  KFWindowController.rb
#  kanaflash
#
#  Created by June Tate-Gans on 1/16/08.
#  Copyright (c) 2008 June Tate-Gans. All rights reserved.
#

require 'osx/cocoa'

class KFWindowController < OSX::NSWindowController
  ib_outlet :questionView
  ib_outlet :answerTextField

  ib_outlet :totalCorrectText
  ib_outlet :totalIncorrectText
  ib_outlet :totalText
  ib_outlet :accuracyPercentageText
  ib_outlet :elapsedTimeText

  ib_outlet :kanaTypePopup
  ib_outlet :testModel

  def awakeFromNib
    @questionView.setEditable(false);

    @kanaTypePopup.removeAllItems
    kana_types = @testModel.kanaTypes.map { |v| v.to_s.capitalize }
    @kanaTypePopup.addItemsWithTitles(kana_types)

    updateView
  end
  
  def updateView
    @totalCorrectText.takeIntValueFrom(@testModel.numCorrect)
    @totalIncorrectText.takeIntValueFrom(@testModel.numIncorrect)
    @totalText.takeIntValueFrom(@testModel.numQuestions)
    @accuracyPercentageText.takeFloatValueFrom(@testModel.accuracyPercentage)
    @questionView.setStringValue(@testModel.question)

    selected_kana = @testModel.kanaTypes.index @testModel.kanaType
    @kanaTypePopup.selectItemAtIndex(selected_kana)
  end

  def resetTest(sender)
    @testModel.reset!
    updateView
  end
  ib_action :resetTest

  def checkAnswer(sender)
    unless @testModel.checkAnswer! @answerTextField.stringValue
      NSRunAlertPanel("KanaFlash", "Incorrect! Correct answer was #{@testModel.answer}.", 'OK', nil, nil)
    end
    
    @testModel.generateNextQuestion!
    updateView
  end
  ib_action :checkAnswer

  def changeKanaType(sender)
    selected_idx = @kanaTypePopup.indexOfSelectedItem
    kana = @testModel.kanaTypes[selected_idx]

    @testModel.setKanaType kana
    @testModel.reset!
    updateView
  end
  ib_action :changeKanaType
end
