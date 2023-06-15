import SwiftUI
import BudouX
import CoreLocation
import SwiftUI
//import AVKit


struct Record: Identifiable {
    var id = UUID()
    let title: String
    let image: Image
    let place: String
    let phenomenon: String
    let detail: String
    
}



struct ContentView: View {
    @State private var isEditMode = false
    @State private var selectedRows: [Record] = [] // 選択された行を保持するSet
    @StateObject private var recordStore = RecordStore()
    @State private var path = NavigationPath()
    

    
    var body: some View {
        NavigationStack(path: $path) {
        ZStack {
            Image("背景6")
                .resizable()
                .ignoresSafeArea()
            
            List {
                ForEach(recordStore.records) { record in
                    HStack {
                        NavigationLink(destination: RecordsDetail(record: record)) {
                            record.image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            Text(record.title)
                                .padding(.leading, 20)
                        }
                    }
                    .listRowBackground(Color.secondary)
                    .foregroundColor(Color.black)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
            .navigationBarTitle(Text("怪奇一覧"), displayMode: .inline)
            
            .navigationBarItems(
                leading: Button(action: {}, label: {
                    Text("記憶を消す")
                }),
                trailing:NavigationLink(destination:AddRecord()) {
                    Text("新たな怪奇")
                }.environmentObject(recordStore)
            )
        }
        }.environmentObject(recordStore) // RecordStoreを環境オブジェクトとして追加
   
        }
    }
//}
    
struct RecordsDetail: View {
    let record: Record

    var body: some View {

            ZStack {
                record.image
                    .resizable()
                    .scaledToFill()
                    .frame(width:800,height: 950)
                    
                    .overlay(
                        VStack {
                            Text(record.title)
                                .font(.title2)
                                .padding(.bottom, 50)
                                .padding(.top, 40)
                                .tracking(2)

                            Text(record.phenomenon)
                                .tracking(2)
                            BudouXText(record.detail)
                                .frame(maxWidth: 350, minHeight: 50, maxHeight: 500)
                                .multilineTextAlignment(.center)
                                .padding(.all, 10)
                                .tracking(1)
                            Text(record.place)
                                .tracking(2)
                                .padding(.bottom, 50)
                        }
                        .frame(maxWidth: 350, minHeight: 50, maxHeight: 500, alignment: .top)
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(50)
                        .padding(.bottom, 100)
                    , alignment: .center)
            }
        }

}

                

struct AddRecord: View {
    @StateObject private var locationManager = LocationManager()
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var title = ""
    @State private var place = ""
    @State private var phenomenon = ""
    @State private var detail = ""
    @State private var selectedImage: UIImage? = nil
    
    @EnvironmentObject var recordStore: RecordStore
    
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        ZStack{
            Image("背景7")
                .resizable()
                .ignoresSafeArea()
            Form {
                Section{
                TextField("タイトル", text: $title)
                TextField("場所", text: $place)
                //.disabled(true) // 住所を表示するために無効化　逆ジオコーディング用？
                TextField("現象", text: $phenomenon)
                TextField("詳細", text: $detail)
                
                Button(action: {
                    imagePickerSourceType = .photoLibrary
                    showImagePicker = true
                }) {
                    Text("写真を選択")
                }
                .padding()
            } .listRowBackground(Color.brown)
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden)
           
        }
        .onAppear {
            locationManager.startUpdatingLocation()
        }
        .onDisappear {
            locationManager.stopUpdatingLocation()
        }
        .onChange(of: locationManager.currentLocation) { location in
                   if let location = location {
                       //逆ジオコーディング用
//                       reverseGeocodeLocation(location: location)
                       //緯度と経度を返す用
                       place = "緯度: \(location.coordinate.latitude), 経度: \(location.coordinate.longitude)"
                   }
               }
//          GPS関係追加前付いていた
//        }
        .navigationBarTitle("遭遇した怪奇")
        
        .navigationBarItems(trailing:
             Button(action: {
                 let newRecord = Record(title: title, image: Image(uiImage: selectedImage ?? UIImage(named: "デフォルト画像")!), place: place, phenomenon: phenomenon, detail: detail)
                 recordStore.addRecord(newRecord)
                 
                 title = ""
                 place = ""
                 phenomenon = ""
                 detail = ""
                 selectedImage = nil
            presentationMode.wrappedValue.dismiss()
             }) {
                 Text("追加")
             }
         )
         .sheet(isPresented: $showImagePicker) {
             ImagePicker(sourceType: imagePickerSourceType, selectedImage: $selectedImage)
         }
     }
    //緯度と経度から都道府県を求めるコードだがCAと表示される為、外部と繋げる必要あり
//    private func reverseGeocodeLocation(location: CLLocation) {
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(location) { placemarks, error in
//            if let error = error {
//                // 逆ジオコーディングのエラーハンドリング
//                print("逆ジオコーディングエラー: \(error.localizedDescription)")
//            } else if let placemark = placemarks?.first {
//                // 住所を取得してplaceに格納
//                print("住所取得してるみたい")
//                if let administrativeArea = placemark.administrativeArea {
//                    place = administrativeArea
//                    print("住所取得してるみたい　administrativeArea")
//                } else {
//                    // 都道府県が見つからない場合のハンドリング
//                    place = "Unknown"
//                }
//            }
//        }
//    }
 }

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?
        
        init(selectedImage: Binding<UIImage?>) {
            _selectedImage = selectedImage
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                selectedImage = pickedImage
            }
            
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

class RecordStore: ObservableObject {
    @Published var records: [Record] = []
    
    init(){
        addInitialRecords()
    }
//
    private func addInitialRecords() {
            records.append(
                Record( title: "霧の向こう側", image: Image("霧の向こう側"), place: "test", phenomenon: "淡い発光体の浮遊", detail: "歩いていると霧が深くなった。振り返るが霧で何も見えない。自然と前に進む足。すると前の方で奇妙な動きの発光を確認。発光体が近づいて思わず目を閉じる。目を開けたら見覚えのある景色。そして、夏の青空が広がっていた。")
            )

            records.append(
                Record( title: "境目", image: Image("境目"), place: "test", phenomenon: "気がつくたら空を逆さに歩いていた", detail: "海に行った。とても青が強くて印象的な空だった。あまりにも印象的で見入っていたら、違和感を覚えた。僕は逆さに空に立っていた。海が空で空が海だった。目を覚ますと砂浜で横になっていた。")
            )
        }
    
        func addRecord(_ record: Record) {
            records.append(record)
        }
        
        func getNextID() -> Int {
            return records.count
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
