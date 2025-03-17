import SwiftUI

// Badge view that uses the outline and fills with team color
struct TeamBadgeView: View {
    let color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    .blendMode(.plusLighter)
            )
            .overlay(
                Circle()
                    .stroke(color.opacity(0.8), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

// Custom badge shape based on the provided outline
struct BadgeShape: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        var path = Path()
        
        // Shield shape with ribbon
        path.move(to: CGPoint(x: width * 0.1, y: height * 0.2))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.1),
            control: CGPoint(x: width * 0.3, y: height * 0.05)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.9, y: height * 0.2),
            control: CGPoint(x: width * 0.7, y: height * 0.05)
        )
        path.addLine(to: CGPoint(x: width * 0.9, y: height * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.9),
            control: CGPoint(x: width * 0.7, y: height * 0.85)
        )
        path.addQuadCurve(
            to: CGPoint(x: width * 0.1, y: height * 0.7),
            control: CGPoint(x: width * 0.3, y: height * 0.85)
        )
        path.closeSubpath()
        
        return path
    }
}

struct PopupView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTeam: TeamData?
    let teams = TeamData.allTeams
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                    ForEach(teams) { team in
                        TeamCell(team: team, isSelected: team.id == selectedTeam?.id)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTeam = team
                                dismiss()
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .navigationTitle("Select Your Team")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Individual team cell component
struct TeamCell: View {
    let team: TeamData
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                TeamBadgeView(color: team.primaryColor)
                    .frame(width: 40, height: 40)
                
                Text(team.shortName)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(team.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.accentColor)
                    .font(.title3)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
    }
}

#Preview {
    PopupView(selectedTeam: .constant(TeamData.allTeams.first))
} 