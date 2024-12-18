import Foundation

class TaskManager: ObservableObject {
    @Published private var tasks: [String: (Toad, [Tadpole])] = [:]
    
    func getToad(for date: Date) -> Toad {
        let key = formatDate(date)
        return tasks[key]?.0 ?? Toad(name: "", description: "", completed: false)
    }
    
    func getTadpoles(for date: Date) -> [Tadpole] {
        let key = formatDate(date)
        return tasks[key]?.1 ?? []
    }
    
    func saveTasks(toad: Toad, tadpoles: [Tadpole], for date: Date) {
        let key = formatDate(date)
        tasks[key] = (toad, tadpoles)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
