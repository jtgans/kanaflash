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

  ib_outlet :testModel

  def awakeFromNib
    @questionView.setEditable(false);
  end
  
  def updateView
    @totalCorrectText.takeIntValueFrom(@testModel.numCorrect)
    @totalIncorrectText.takeIntValueFrom(@testModel.numIncorrect)
    @totalText.takeIntValueFrom(@testModel.numQuestions)
    @accuracyPercentageText.takeFloatValueFrom(@testModel.accuracyPercentage)
    @questionView.setStringValue(@testModel.question)
  end

  def resetTest(sender)
    @testModel.reset!
    updateView
  end
  ib_action :resetTest

  def checkAnswer(sender)
    if @testModel.checkAnswer! @answerTextField.stringValue
      NSRunAlertPanel("KanaFlash", "Correct!", 'OK', nil, nil)
    else
      NSRunAlertPanel("KanaFlash", "Incorrect! Correct answer was #{@testModel.answer}.", 'OK', nil, nil)
    end
    
    @testModel.generateNextQuestion!
    updateView
  end
  ib_action :checkAnswer
end
