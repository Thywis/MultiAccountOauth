//
//  DynamicStorage.swift
//


import Foundation

//Don't use any optional value!

public class DynamicStorage: NSObject {
    
    
    // MARK: Setup, teardown and description
    public required override init() {
        
        super.init()
        
        let classPrefix = String(describing: self).components(separatedBy: ".").first?.components(separatedBy: "<").last!
        
        let defaults = UserDefaults.standard
        let properties = Mirror(reflecting: self).children.flatMap { child -> (String?) in return child.label }
        for property in properties {
            let defaultKey = classPrefix! + "_" + property
            let value = defaults.value(forKey: defaultKey)
            if value != nil {
                setValue(value, forKey: property)
            }
        }
        registerObservers()
    }
    
    deinit {
        unregisterObservers()
    }
    
    // MARK: Key-Value Observation
    
    /// Register observers for all of the children properties.
    private func registerObservers() {
        let properties = Mirror(reflecting: self).children.flatMap { child -> (String?) in return child.label }
        
        for property in properties {
            addObserver(self, forKeyPath: property, options: NSKeyValueObservingOptions([.prior, .old, .new]), context: nil)
        }
    }
    
    /// Remove observers for all of the children properties.
    private func unregisterObservers() {
        let properties = Mirror(reflecting: self).children.flatMap { child -> (String?) in return child.label }
        
        for property in properties {
            removeObserver(self, forKeyPath: property)
        }
    }
    
    public override func setValue(_ value: Any?, forUndefinedKey key: String) {
        return
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //We must have a keyPath and it must not be a path.
        
        let classPrefix = String(describing: self).components(separatedBy: ".").first?.components(separatedBy: "<").last!
        
        guard let key = keyPath , key.range(of: ".") == nil else {
            print("\(String(describing: self)): observeValueForKeyPath called with a keyPath of \"\(String(describing: keyPath))\" we don't handle key paths; returning.")
            return
        }
        
        let defaults = UserDefaults.standard
        
        if let oldValue = change?[NSKeyValueChangeKey.oldKey], let newValue = change?[NSKeyValueChangeKey.newKey] , !(oldValue as AnyObject).isEqual(newValue) {
            
            let defaultKey = classPrefix! + "_" + key
            if let value = value(forKey: key) {
                defaults.setValue(value, forKey: defaultKey)
            } else {
                defaults.setValue(nil, forKey: defaultKey)
            }
        }
    }
    
}

