package br.ufrpe.bds.assistech.view;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JButton;
import java.awt.GridLayout;
import java.awt.Label;
import java.awt.FlowLayout;
import java.awt.Button;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.Font;

public class MenuNovoView extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					MenuNovoView frame = new MenuNovoView();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public MenuNovoView() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 627, 573);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(new GridLayout(1, 0, 0, 0));
		
		JPanel panel = new JPanel();
		contentPane.add(panel);
		panel.setLayout(new GridLayout(0, 1, 0, 0));
		
		Label label = new Label("Bartô Alheiros Informática");
		label.setFont(new Font("Arial Black", Font.PLAIN, 20));
		label.setAlignment(Label.CENTER);
		panel.add(label);
		
		JButton btnNewButton = new JButton("Cadastrar Cliente");
		panel.add(btnNewButton);
		
		JButton btnNewButton_1 = new JButton("Cadastrar Equipamento");
		panel.add(btnNewButton_1);
		
		Label label_1 = new Label("Todos os direitos reservados a: Bartolomeu Alheiros. 2025.");
		label_1.setAlignment(Label.CENTER);
		panel.add(label_1);

	}

}
