//
//  RootStepper.swift
//  tawktestios
//
//  Created by JMC on 25/7/21.
//

import RxFlow
import RxCocoa

enum RootStep: Step {
  case main
}

class RootStepper: Stepper {

  var steps = PublishRelay<Step>()

  var initialStep: Step {
    return RootStep.main
  }
}
