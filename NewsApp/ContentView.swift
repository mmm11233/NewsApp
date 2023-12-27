//
//  ContentView.swift
//  NewsApp
//
//  Created by Mariam Joglidze on 27.12.23.
//

import SwiftUI

struct UIKitInSwiftUIView: View {
    @State private var items: [Article] = []
    let apiService = ProductManager()
    
    var body: some View {
        VStack {
            if !items.isEmpty {
                UITableViewWrapper(data: items)
                    .accessibilityLabel("Articles Table")
            } else {
                Text("Loading...")
                    .accessibilityLabel("Loading Articles")
                    .onAppear {
                        apiService.fetchProducts { receivedData in
                            DispatchQueue.main.async {
                                self.items = receivedData
                            }
                        }
                    }
            }
        }
    }
}

struct UITableViewWrapper: UIViewRepresentable {
    typealias UIViewType = UITableView
    
    let data: [Article]
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = context.coordinator
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.rowHeight = 250
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .red
        tableView.isAccessibilityElement = false // Set false for containing elements
        
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        // Update UI or handle changes if needed
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: data)
    }
    
    class Coordinator: NSObject, UITableViewDataSource {
        let data: [Article]
        
        init(data: [Article]) {
            self.data = data
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            let item = data[indexPath.row]
            cell.textLabel?.text = item.author
            cell.textLabel?.text = item.title
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
            
            // Set accessibility label and hints for VoiceOver
            cell.isAccessibilityElement = true
            cell.accessibilityLabel = "\(String(describing: item.author)), \(item.title)"
            cell.accessibilityTraits = .button
            cell.accessibilityHint = "Double-tap to read more about this article"
            
            cell.textLabel?.widthAnchor.constraint(equalToConstant: 250).isActive = true
            cell.textLabel?.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 170).isActive = true
            
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
                           .scaledFont(size: 17, weight: .regular)
            
            cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
            
            cell.imageView?.widthAnchor.constraint(equalToConstant: 150).isActive = true
            cell.imageView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            if let imageUrlString = item.urlToImage, let imageUrl = URL(string: imageUrlString) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData)
                            cell.imageView?.image = image
                            cell.setNeedsLayout()
                        }
                    }
                }
            } else {
                cell.imageView?.image = UIImage(named: "placeholderImage")
            }
            return cell
        }
    }
}

extension UIFont {
    func scaledFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: .body)
        _ = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        return metrics.scaledFont(for: font, compatibleWith: UITraitCollection(displayScale: 1.0))
    }
}


#Preview {
    UIKitInSwiftUIView()
}
