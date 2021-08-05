//
//  GithubStepper.swift
//  tawktestios
//
//  Created by JMC on 24/7/21.
//

import RxCocoa
import RxFlow

enum GithubStep: Step {
    case userList
    case userProfile(user: GithubUser)
    case dismiss
}

final class GithubStepper: Stepper {

    var steps = PublishRelay<Step>()

    var initialStep: Step {
        GithubStep.userList
    }
}

