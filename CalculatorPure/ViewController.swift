import UIKit
import SnapKit

class ViewController: UIViewController {

    // 수식 및 결과 표시 라벨
    let displayLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        //배경화면 속성 제거
//        view.backgroundColor = .black
        
        // 수식 및 결과 표시 라벨 설정
        displayLabel.backgroundColor = .black
        displayLabel.textColor = .white
        displayLabel.text = "0"
        displayLabel.font = UIFont.boldSystemFont(ofSize: 60)
        displayLabel.textAlignment = .right
        view.addSubview(displayLabel)
        
        displayLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalToSuperview().offset(200)
            $0.height.equalTo(100)
        }

        // 버튼 타이틀 배열
        let titles: [[String]] = [
            ["7", "8", "9", "+"],
            ["4", "5", "6", "-"],
            ["1", "2", "3", "*"],
            ["AC", "0", "=", "/"]
        ]
        
        // 버튼 생성 및 가로 스택뷰 설정
        var buttonRows: [UIStackView] = []
        for row in titles {
            var buttonRow: [UIButton] = []
            for title in row {
                let backgroundColor: UIColor = (title == "+" || title == "-" || title == "*" || title == "/" || title == "AC" || title == "=") ? .orange : UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0)
                let button = makeButton(titleValue: title, action: #selector(buttonClicked(_:)), backgroundColor: backgroundColor)
                buttonRow.append(button)
            }
            let stackView = UIStackView(arrangedSubviews: buttonRow)
            stackView.axis = .horizontal
            stackView.spacing = 10
            stackView.distribution = .fillEqually
            stackView.snp.makeConstraints {
                $0.height.equalTo(80)
            }
            buttonRows.append(stackView)
        }

        // 세로 스택뷰 생성 및 UI 설정
        let verticalStackView = UIStackView(arrangedSubviews: buttonRows)
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.distribution = .fillEqually
        view.addSubview(verticalStackView)
        
        verticalStackView.snp.makeConstraints {
            $0.width.equalTo(350)
            $0.top.equalTo(displayLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }
    }

    private func makeButton(titleValue: String, action: Selector, backgroundColor: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(titleValue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        button.backgroundColor = backgroundColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 40
        button.snp.makeConstraints {
            $0.height.width.equalTo(80)
        }
        button.layer.cornerRadius = 40
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc
    private func buttonClicked(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }

        if title == "AC" {
            displayLabel.text = "0"
        } else if title == "=" {
            if let expression = displayLabel.text, let result = calculate(expression: expression) {
                displayLabel.text = "\(result)"
            } else {
                displayLabel.text = "Error"
            }
        } else {
            if displayLabel.text == "0" {
                displayLabel.text = title
            } else {
                displayLabel.text?.append(title)
            }
        }

        if let displayText = displayLabel.text, displayText.first == "0" && displayText.count > 1 && !displayText.contains("+") && !displayText.contains("-") && !displayText.contains("*") && !displayText.contains("/") {
            displayLabel.text = String(displayText.dropFirst())
        }

        print("\(title) 버튼이 클릭되었습니다.")
    }

    /// 수식 문자열을 넣으면 계산해주는 메서드.
    ///
    /// 예를 들어 expression 에 "1+2+3" 이 들어오면 6 을 리턴한다.
    /// 잘못된 형식의 수식을 넣으면 앱이 크래시 난다. ex) "1+2++"
    private func calculate(expression: String) -> Int? {
        let expression = NSExpression(format: expression)
        if let result = expression.expressionValue(with: nil, context: nil) as? Int {
            return result
        } else {
            return nil
        }
    }
}
