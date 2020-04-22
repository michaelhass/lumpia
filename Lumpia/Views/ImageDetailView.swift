//
//  ImageDetailView.swift
//  Lumpia
//
//  Created by Michael Haß on 22.04.20.
//  Copyright © 2020 Michael Hass. All rights reserved.
//

import SwiftUI

struct ImageDetailView: View {

    private let imageData: ImageData

    var aspectRatio: CGSize {
        return CGSize(width: imageData.width, height: imageData.height)
    }

    init(imageData: ImageData) {
        self.imageData = imageData
    }

    var body: some View {

        GeometryReader { geoProxy in
            ScrollView {
                VStack {
                RemoteImage(url: self.imageData.urls.small,
                        cache: shared?.imageCache) {
                            Rectangle().fill(Color(hex: self.imageData.color))
                }.aspectRatio(self.aspectRatio, contentMode: .fill)
                    .frame(width: geoProxy.size.width)
                    .padding(.bottom)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(self.imageData.description ?? self.imageData.altDescription ?? "")
                            .font(.title)
                            .bold()
                            .lineLimit(nil)
                        Text(self.imageData.user.name).lineLimit(2)

                        Spacer()
                        self.formattedDate(self.imageData.createdAt)
                        Text("Size \(self.imageData.width) x \(self.imageData.height)")
                        Spacer()

                    }.padding()
                        .frame(width: geoProxy.size.width, alignment: .leading)

                    Spacer()
                }
            }
        }
    }

    func formattedDate(_ dateString: String) -> some View {
        let formattedtString =  ISO8601DateFormatter().date(from: dateString).map { date in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, yyyy - HH:mm"

            return formatter.string(from: date)
        } ?? ""

        return Text(formattedtString).lineLimit(2)
    }

}

struct ImageDetailView_Previews: PreviewProvider {

    static var previews: some View {
        return ImageDetailView(imageData: .testData(withId: "0"))
    }
}
