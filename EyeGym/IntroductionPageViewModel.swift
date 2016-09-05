//
//  IntroductionPageViewModel.swift
//  EyeGym
//
//  Created by Мануэль on 03.11.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import Foundation

class IntroductionPageViewModel
{
    private var currentPage = 1 {
        didSet
        {
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
            "Долго работаете за компьютером?\nВаши глаза смотрят на одну близкую точку.\nЭто создает неравномерную нагрузку на глазные мышцы.\nЧто ведет к спазмированию, и изменяет форму глазного яблока.",
            "Наша задача – развести глаза в стороны и расслабить спазмированные мышцы. Объедините изображение справа и слева в одно изображение.            Картинки будут медленно расходиться, расслабляя мышцы хрусталика.",
            "Хинт: Левый глаз смотрит на левое изображение, правый глаз на правое."
        ]
    }()
    
    func firstPageText() -> String {
        
        return introductionPages.first!.text
    }
    
    func nextPageText() -> String {
        
        guard currentPage < introductionPages.count else { currentPage = 1; return introductionPages.first!.text }
        
        currentPage += 1
        
        return introductionPages[currentPage - 1].text
    }
    
    private class func fillPagesArray() -> [IntroductionPage] {
        
        var pages = [IntroductionPage]()
        
        for text in textsForPages
        {
            pages.append(IntroductionPage(with: text))
        }
        
        return pages
    }    
}
