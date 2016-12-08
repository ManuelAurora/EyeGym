//
//  IntroductionPageViewModel.swift
//  EyeGym
//
//  Created by Мануэль on 03.11.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation
import UIKit //Used only for UIImage, do not use this framework for somthing else here!

class IntroductionPageViewModel
{
    private var currentPage = 1 {
        didSet
        {
            //if current page is last - will send notification about it to the view controller.
            if currentPage == introductionPages.count
            {
                let notif = Notification(name: .init(ViewModelNotificationNames.lastIntroPageDidAppear.rawValue))
                NotificationCenter.default.post(notif)
            }
        }
    }
    
    private lazy var introductionPages: [IntroductionPage] = {
        
        return IntroductionPageViewModel.fillPagesArray()
    }()
    
    private static var textsForPages: [String] = {
        
        return [
            "Долго работаете за компьютером?\n\nВаши глаза смотрят на одну близкую точку.\n\nЭто создает неравномерную нагрузку на глазные мышцы.\n\nЧто ведет к спазмированию, и изменяет форму глазного яблока.",
            "Наша задача – развести глаза в стороны и расслабить спазмированные мышцы.\n\nОбъедините изображение справа и слева в одно изображение.\n\nКартинки будут медленно расходиться, расслабляя мышцы хрусталика.",
            "Хинт: Левый глаз смотрит на левое изображение, правый глаз на правое."
        ]
    }()
    
    func firstPageData() -> (text: String?, image: UIImage?) {
        
        return (introductionPages.first?.text, introductionPages.first?.image)
    }    
    
    func nextPageData() -> (text: String?, image: UIImage?) {
        
        guard currentPage < introductionPages.count else {
            
            currentPage = 1; return (introductionPages.first?.text, introductionPages.first?.image)
        }
        
        currentPage += 1
        
        return (introductionPages[currentPage - 1].text, introductionPages[currentPage - 1].image)
    }
    
    private class func fillPagesArray() -> [IntroductionPage] {
        
        var firstPage  = IntroductionPage(with: textsForPages.first!)
        var secondPage = IntroductionPage(with: textsForPages[1])
        let thirdPage  = IntroductionPage(with: textsForPages[2])
        
        firstPage.image  = UIImage(withAsset: .closeObjectLook)
        secondPage.image = UIImage(withAsset: .farObjectLook)
                
        return [firstPage, secondPage, thirdPage]
    }    
}
















