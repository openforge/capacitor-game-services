//
//  GameServices.swift
//  App
//
//

import Foundation

import Capacitor
import GameKit
import Firebase
import AuthenticationServices


@available(iOS 13.0, *)
@objc(GameServices)
public class GameServices: CAPPlugin, GKGameCenterControllerDelegate {
    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    var signInHandler: GetAppleSignInHandler?
    
    /**
     TODO: rename authentication loop? something similar? Iteration? Auth Cycle Iteration? how will this actually loop tho?
     TODO: need to test behavior after signing out, will it auth to firebase on first pass, what if no internet on load, how to cycle, "waiting for connection" on auth page?
     "As part of your Game Center integration, you define an authentication handler that is called at multiple points in the Game Center authentication process."
     https://firebase.google.com/docs/auth/ios/game-center#integrate_game_center_sign-in_into_your_game
     */
    
    
    
    // TODO: why is the flow on this call so off????!
    // TODO: will this ever actually do any work with ios side?
    @objc func signIn(_ call: CAPPluginCall) {
        let localPalyer = GKLocalPlayer.local
        
        localPalyer.authenticateHandler = { vc, error in
            guard error == nil else {
                return
            }
            if let vc = vc {
                // TODO: test if this needs to be wrapped more broadly in order to run properly, hard to test without signout method!
                DispatchQueue.main.async {
                    self.bridge.viewController.present(vc, animated: true)
                }
            } else if localPalyer.isAuthenticated {
                print("[GameServices] local player is authenticated")
                
                GameCenterAuthProvider.getCredential() { (credential, error) in
                    if error != nil {
                        return
                    }
                    
                    Auth.auth().signIn(with: credential!) { (user, error) in
                        if error != nil {
                            return
                        }
                        
                        Auth.auth().currentUser?.getIDToken() { (anIDToken, error) in

                            print("GameServices anIDToken \(anIDToken ?? "")")
                            call.resolve(["token": anIDToken ?? ""])
                        };
                        
                    }
                    
                }
            } else {
                // error
            }
        }
    }
    
    @objc func showLeaderboard(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = self
            vc.viewState = .leaderboards
            vc.leaderboardIdentifier = call.getString("leaderboardId")
            self.bridge.viewController.present(vc, animated: true, completion: {() -> Void in
                call.resolve(["result": "[GameServices] Achievement is about to present"])
            })
        }
    }
    
    @objc func showAchievements(_ call: CAPPluginCall) {
        print("[GameServices] Showing Achievements")
        DispatchQueue.main.async {
            let vc = GKGameCenterViewController()
            vc.gameCenterDelegate = self;
            vc.viewState = .achievements
            self.bridge.viewController.present(vc, animated: true, completion: {() -> Void in
                call.resolve(["result": "[GameServices] Achievement is about to present"])
            })
        }
    }
    
    @objc func submitScore(_ call: CAPPluginCall) {
        // default not working!!!
        let leaderboardId = call.getString("leaderboardId") ?? "testLeaderboard" // for these defaults, have a default leaderboard set here? instead of setting a players default leaderboard??
        
        // TODO: is there any additional error handling here?
        let score = Int64(call.getInt("score") ?? 0) // TODO: test what happens when expects an Integer but gets booleans, or even a string
        print("[GameServices] Sumbitting Score \(score) to leaderboard id \(leaderboardId)")
        
        let newScore = GKScore(leaderboardIdentifier: leaderboardId)
        newScore.value = score
        
        GKScore.report([newScore]) { error in
            guard error == nil else {
                let errorMessage = "[GameServices] \(error?.localizedDescription ?? "")"
                print(errorMessage)
                call.reject(errorMessage)
                return
            }
            let successMessage = "[GameServices] Report Score Success"
            print(successMessage)
            call.resolve(["result": successMessage])
        }
    }
    
    
    
    
    @objc func unlockAchievement(_ call: CAPPluginCall) {
        print("unlockAchievement:called")
        progressAchievementDelegate(call, 100.0)
    }
    
    @objc func progressAchievement(_ call: CAPPluginCall) {
        print("progressAchievement:called")
        progressAchievementDelegate(call, call.getDouble("percentComplete"))
    }
    
    @objc func resetAllAchievementProgress(_ call: CAPPluginCall) {
        print("resetAllAchievementProgress:called")
        
        GKAchievement.resetAchievements(completionHandler: { error in
            guard error == nil else {
                let errorMessage = "[GameServices] \(error?.localizedDescription ?? "Some Achievements Error")"
                print(errorMessage)
                call.reject(errorMessage)
                return
            }
            print("[GameServices] Reset Achievement Called")
            call.resolve()
        })
    }
    
    /**
     Success response here means nothing?????
     TODO: Test if ios game service can set achievement progress that is backwards?
     could do setValue on key progressComplete to possibly clean this reuse up
        logging is going to get messed up if reading values only in delegate
     
     need to have way to know when something fails
     
        this is throttled, not buffered, how should it be communicated that sequential calls to the same achievement wont register

     */
    private func progressAchievementDelegate(_ call: CAPPluginCall, _ percentComplete: Double?) {
        let achievementId = call.getString("achievementId") ?? "";
        let progressComplete = percentComplete ?? 100.0
        
        print("[GameServices] Setting Achievement Percentage \(progressComplete)")
                        
        let newAchievement = GKAchievement(identifier: achievementId)
        newAchievement.percentComplete = progressComplete
        
        GKAchievement.report([newAchievement]) { error in
            guard error == nil else {
                print("[GameServices] \(error?.localizedDescription ?? "")")
                call.reject("[GameServices] \(error?.localizedDescription ?? "")")
                return
            }
            let successMessage = "[GameServices] Achievement Progress Was Reported"
            print(successMessage)
            call.resolve(["result": successMessage])
        }
    }
    
    
    func appleSignIn(_ call: CAPPluginCall, linkTo: AuthCredential) {
        call.save()
        DispatchQueue.main.async {
            self.signInHandler = GetAppleSignInHandler(call: call, window: (self.bridge?.getWebView()?.window)!)
        }
    }
}

// source: https://www.ionicanddjangotutorial.com/ionic-apple-signin-with-capacitor.html
@available(iOS 13.0, *)
class GetAppleSignInHandler: NSObject, ASAuthorizationControllerDelegate {
    var call: CAPPluginCall
    var window: UIWindow
    var identityTokenString: String?
    
    init(call: CAPPluginCall, window: UIWindow) {
        self.call = call
        self.window = window
        super.init()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        call.error(error.localizedDescription)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let identityTokenData = appleIDCredential.identityToken, let theIdentityTokenString = String(data: identityTokenData, encoding: .utf8) {
                self.identityTokenString = theIdentityTokenString
            }
        }
    }
}


@available(iOS 13.0, *)
extension GetAppleSignInHandler: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window;
    }
}
