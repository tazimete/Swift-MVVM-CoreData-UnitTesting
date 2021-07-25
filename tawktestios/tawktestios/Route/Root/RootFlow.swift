//
//  RootFlow.swift
//  tawktestios
//
//  Created by JMC on 25/7/21.
//

import RxFlow

class RootFlow: Flow {
    var root: Presentable {
        rootWindow
    }

    let rootWindow: UIWindow

    init(rootWindow: UIWindow) {
        self.rootWindow = rootWindow
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = transform(step: step) as? RootStep else {
            return .none
        }
        switch step {
        case .main:
            return showRootViewController()
        }
    }

    private func transform(step: Step) -> Step? {
        return RootStep.main
    }
}

private extension RootFlow {

    func showRootViewController() -> FlowContributors {
        let githubFlow = GithubFlow()

        Flows.use(githubFlow, when: .ready) { [rootWindow] (githubnRoot: UINavigationController) in
            rootWindow.rootViewController = githubnRoot
            rootWindow.makeKeyAndVisible()
        }
        return .one(flowContributor: .contribute(withNextPresentable: githubFlow, withNextStepper: GithubStepper()))
    }
}

