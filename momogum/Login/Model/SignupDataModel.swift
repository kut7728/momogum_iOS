//
//  SignupDataModel.swift
//  momogum
//
//  Created by 서재민 on 2/6/25.
//
import Foundation


// 사용자로부터 받는 데이터
@Observable
class SignupDataModel{
    var name = ""
    var nickname = ""
    
    func creatUser(){
        print("name",name)
        print("nickname",nickname)
    }
}
