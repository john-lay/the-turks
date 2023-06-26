using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttack : MonoBehaviour
{
    
    public Animator Animator;

    private void Update()
    {
        if (Input.GetButtonDown("Fire1"))
        {
            Debug.Log("Fire 1 (ctrl) pressed");
            Animator.SetBool("Attacking",  true);
        }
    }

    /// <summary>
    /// Function called as an `Animation Event` on the `player-attack-down.anim` animation 
    /// </summary>
    public void AttackComplete()
    {
        Debug.Log("Attack animation complete");
        Animator.SetBool("Attacking",  false);
    }
}
