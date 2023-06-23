using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    public float moveSpeed = 5f;

    public Rigidbody2D rb;

    public Animator Animator;
    
    Vector2 movement;

    // input logic
    void Update()
    {
        movement.x = Input.GetAxisRaw("Horizontal");
        movement.y = Input.GetAxisRaw("Vertical");
        
        Animator.SetFloat("Horizontal",  movement.x);
        Animator.SetFloat("Vertical",  movement.y);
        Animator.SetFloat("Speed",  movement.sqrMagnitude);
    }

    // movement and physics logic
    private void FixedUpdate()
    {
        rb.MovePosition(rb.position + movement * (moveSpeed * Time.fixedDeltaTime));
    }
}
